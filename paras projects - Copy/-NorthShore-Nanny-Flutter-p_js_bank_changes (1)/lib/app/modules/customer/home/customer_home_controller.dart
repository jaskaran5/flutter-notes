import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:northshore_nanny_flutter/app/data/api/api_helper.dart';
import 'package:northshore_nanny_flutter/app/data/storage/storage.dart';
import 'package:northshore_nanny_flutter/app/models/customer_home_dashboard_response_model.dart';
import 'package:northshore_nanny_flutter/app/models/nanny_favourite_response_model.dart';
import 'package:northshore_nanny_flutter/app/models/nanny_profile_model.dart';
import 'package:northshore_nanny_flutter/app/modules/customer/get_nanny_profile/get_nanny_profile_view.dart';
import 'package:northshore_nanny_flutter/app/res/constants/api_urls.dart';
import 'package:northshore_nanny_flutter/app/res/constants/app_constants.dart';
import 'package:northshore_nanny_flutter/app/res/constants/enums.dart';
import 'package:northshore_nanny_flutter/app/res/constants/extensions.dart';
import 'package:northshore_nanny_flutter/app/res/constants/string_contants.dart';
import 'package:northshore_nanny_flutter/app/res/theme/dimens.dart';
import 'package:northshore_nanny_flutter/app/utils/app_utils.dart';
import 'package:northshore_nanny_flutter/app/utils/custom_toast.dart';
import 'package:northshore_nanny_flutter/app/utils/utility.dart';
import 'package:northshore_nanny_flutter/app/widgets/custom_dynamic_marker.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:widget_to_marker/widget_to_marker.dart';

class CustomerHomeController extends GetxController {
  final ApiHelper _apiHelper = ApiHelper.to;

  String? selectedGender = '';

  double distanceLowerValue = Dimens.zero;
  double distanceHigherValue = 25;
  double ageLowerValue = 13;
  double ageHigherValue = 50;
  RxString address = ''.obs;

  final debounce = Debouncer(delay: const Duration(seconds: 1));

  /// SHOW NANNY TILE
  RxString nannyName = ''.obs;
  RxString nannyImage = ''.obs;

  RxBool nannyFavourite = false.obs;
  RxString nannyRatingCount = '0'.obs;
  List<RatingList> nannyRatingList = [];
  RxInt nannyUserId = 0.obs;

  RxString nannyDescription = ''.obs;
  RxString nannyTotalReviews = '0'.obs;
  RxString nannyDistance = ''.obs;
  RxString nannyAge = ''.obs;
  RxString nannyExperience = ''.obs;

  RxBool isNannyDataLoading = true.obs;

  /// FILTER

  RxString filterMinMiles = "0".obs;
  RxString filterMaxMiles = "25".obs;


  /// use to select Date
  DateTime selectedDate = DateTime.now();

  /// use to select Time
  DateTime selectedTime = DateTime.now();

  Future<void> updateNannyTile({
    required String name,
    required bool isFavourite,
    required String ratingCount,
    required String description,
    required String totalReviews,
    required String distance,
    required String age,
    required String experience,
    required String image,
    required int userId,
    required List<RatingList> ratingList,
  }) async {
    log("exper::->> $experience");
    log("exper is fav::->> $isFavourite");
    log('Tile in map Data : updateNanny');

    nannyName.value = name;
    nannyFavourite.value = isFavourite;
    nannyRatingCount.value = ratingCount;
    nannyDescription.value = description;
    nannyTotalReviews.value = totalReviews;
    nannyDistance.value = distance;
    nannyAge.value = age;
    nannyExperience.value = experience;
    nannyImage.value = image;
    nannyUserId.value = userId;
    nannyRatingList = ratingList;
    update();
  }

  List<String> genderList = GenderConstant.values
      .map((e) => e.genderName.capitalizeFirst.toString())
      .toList();
  RxBool showListView = true.obs;
  RxBool isGoogleMap = false.obs;
  Set<Marker> markers = {};

  RxList<NannyDataList> homeNannyList = <NannyDataList>[].obs;

  late GoogleMapController googleMapController;

  RxBool isNannyMarkerVisible = false.obs;

  toggleIsNannyMarkerVisible() {
    isNannyMarkerVisible.value = !isNannyMarkerVisible.value;
    update();
  }

  /// UPDATE SCREEN WITH TAP -- GOOGLE MAP/ LIST VIEW

  updateScreen() async {
    isGoogleMap.value = !isGoogleMap.value;
    showListView.value = !showListView.value;

    if (showListView.value) {
      isNannyMarkerVisible.value = false;
    }
    update();
  }

  /// *******---------------------------->>>>>>>>>>> ON MAP CREATED

  /// CONVERT DATE TIME

  String convertDateTimeToString(DateTime dateTime) {
    final dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
    return dateFormat.format(dateTime);
  }

  /**  */

  /// GET NANNY LIST DATA WITH LOCATION IN DASHBOARD
  getDashboardApi() async {
    try {
      if (!(await Utils.hasNetwork())) {
        return;
      }
      final dateTime = returnFinalTimeAccordingToDate(
          selectedTime: selectedTime, day: selectedDate);

      debugPrint('final Date Time :$dateTime');
      Map<String, dynamic> body;
        body = {
          "minMiles": filterMinMiles.value,
          "maxMiles": filterMaxMiles.value,
          "minAge": null,
          "maxAge": null,
          "dateTime": null,
          "gender": null,
          "name": null,
        };
      // } else {
      //   body = {
      //     "minMiles": null,
      //     "maxMiles": null,
      //     "minAge": null,
      //     "maxAge": null,
      //     "dateTime": null,
      //     "gender": null,
      //     "name": null,
      //   };
      // }

      debugPrint('dashboard api body :$body');
      _apiHelper.postApi(ApiUrls.userDashBoard, body).futureValue(
          (value) async {
        Utils.loadingDialog();
        var res = CustomerHomeDashboardResponseModel.fromJson(value);
        var permissionStatus = await permission.Permission.location.status;
        if (!permissionStatus.isGranted) {
          await Utils.getLocationPermissionStatus(
              title:
                  'Allow the app to access your precise location so you can find nearby nannies.');
        }
        if (res.response.toString() ==
            AppConstants.apiResponseSuccess.toString()) {
          log("response success $res");

          homeNannyList.value = res.data?.dataList ?? [];
          address.value = res.data?.address ?? '';
          latitude = double.parse(res.data?.latitude.toString() ??
              Storage.getValue(StringConstants.latitude).toString());
          longitude = double.parse(res.data?.longitude.toString() ??
              Storage.getValue(StringConstants.longitude).toString());
          isNannyDataLoading.value = false;
          update();
          Utils.closeDialog();
          if (res.data != null && res.data?.dataList?.isNotEmpty == true) {
            updateNannyMarkers();
          } else {
            Utils.closeDialog();
          }
        } else {
          toast(msg: res.message.toString(), isError: true);
          isNannyDataLoading.value = false;
          Utils.closeDialog();
          update();
        }
      }, retryFunction: getDashboardApi);
    } catch (e, s) {
      toast(msg: e.toString(), isError: true);
      toast(msg: s.toString(), isError: true);
      isNannyDataLoading.value = false;
      printError(info: "Get dashboard data post  API ISSUE $s");
    }
  }

  Future<void> updateNannyMarkers() async {
    markers.clear();
    update();
    log("nanny list-->> ${homeNannyList.length}");
    for (int a = 0; a < homeNannyList.length - 1; a++) {
      markers.add(
        Marker(
            markerId: MarkerId("$a"),
            position: LatLng(
                double.tryParse(homeNannyList[a].latitude.toString()) ?? 0.0,
                double.tryParse(homeNannyList[a].longitude.toString()) ?? 0.0),
            icon: await TextOnImage(
              image: homeNannyList[a].image,
            ).toBitmapDescriptor(
                logicalSize: const Size(200, 200),
                imageSize: const Size(200, 200)),
            onTap: () async {
              log("aaaaaaa:-->> $a");
              log("aaaaaaa:-->> ${homeNannyList[a].isFavorite}");
              updateNannyTile(
                      name: homeNannyList[a].name,
                      isFavourite: homeNannyList[a].isFavorite ?? false,
                      ratingCount: homeNannyList[a].rating == 0.0
                          ? '0'
                          : homeNannyList[a].rating?.toStringAsFixed(1) ?? '0',
                      description: homeNannyList[a].aboutMe,
                      totalReviews: homeNannyList[a].reviewCount.toString(),
                      distance:
                          homeNannyList[a].distance?.toInt().toString() ?? '0',
                      age: homeNannyList[a].age.toString(),
                      experience: homeNannyList[a].experience.toString(),
                      image: homeNannyList[a].image.toString(),
                      userId: homeNannyList[a].id ?? 0,
                      ratingList: homeNannyList[a].ratingList ?? [])
                  .then((value) async {
                toggleIsNannyMarkerVisible();

                log("on tap on marker");
              });
            }),
      );
    }
    update();
  }

  double latitude = 0.0;
  double longitude = 0.0;

  toggleFavouriteAndUnFavouriteApi(
      {required int userId, required bool isFavourite})
  {
    try {
      var body = {
        "toUserId": userId,
        "isFavorite": isFavourite,
      };

      _apiHelper.postApi(ApiUrls.addOrRemoveFavoriteNanny, body).futureValue(
          (value) {
        var res = NannyFavouriteResponseModel.fromJson(value);

        if (res.response.toString() ==
            AppConstants.apiResponseSuccess.toString()) {
          log("response success");
          nannyFavourite.value = !nannyFavourite.value;

          getDashboardApi();

          update();
        }
      }, retryFunction: () {});
    } catch (e, s) {
      toast(msg: e.toString(), isError: true);
      printError(info: "Get dashboard data post  API ISSUE $s");
    }
  }

  /// used to check filter is applied or not.
  RxBool isFilterApply = false.obs;

  onClickOnFilterApply({required bool isResetFilters}) async {
    var selectedTimeDate = Utility.addTimeToList(
        dates: [selectedDate], addTime: TimeOfDay.fromDateTime(selectedTime));

    log("seleceted datetime -->> $selectedTimeDate");
    log("distacne lower: $distanceLowerValue");
    log("distacne higher: $distanceHigherValue");
    log(" gender: $selectedGender");
    log("age lower: $ageLowerValue");
    log("age higher: $ageHigherValue");

    log("date: $selectedDate");
    log("time: $selectedTime");

    try {
      if (!(await Utils.hasNetwork())) {
        return;
      }
      Map<String, dynamic>? body;
      if (isResetFilters) {
        debugPrint('>>>>>>>>>>>>reset filter Apply');
        body = {
          "minMiles": 0,
          "maxMiles": 25,
          "minAge": null,
          "maxAge": null,
          "dateTime": null,
          "gender": null,
          "name": '',
        };
        isFilterApply.value = false;
        update();
      } else {
        final dateTime = returnFinalTimeAccordingToDate(
            selectedTime: selectedTime, day: selectedDate);

        debugPrint('final Date Time filter :$dateTime');
        debugPrint('>>>>>>>>>>>>Apply filter ');
        body = {
          "minMiles": distanceLowerValue.toInt(),
          "maxMiles": distanceHigherValue.toInt(),
          "minAge": ageLowerValue.toInt(),
          "maxAge": ageHigherValue.toInt(),
          "dateTime": dateTime.toUtc().toIso8601String(),
          "gender": selectedGender == "Female"
              ? 2
              : selectedGender == "Male"
                  ? 1
                  : 0,
          "name": "",
        };
        isFilterApply.value = true;
        update();
      }
      log("body apply filter:-->. $body");
      log("isFilter apply >>>>>>>>>>. $isFilterApply");
      _apiHelper.postApi(ApiUrls.userDashBoard, body).futureValue((value) {
        var res = CustomerHomeDashboardResponseModel.fromJson(value);

        if (res.response.toString() ==
            AppConstants.apiResponseSuccess.toString()) {
          log("response success");
          homeNannyList.value = res.data?.dataList ?? [];
          address.value = res.data?.address ?? '';
          latitude = double.parse(res.data?.latitude.toString() ??
              Storage.getValue(StringConstants.latitude).toString());
          longitude = double.parse(res.data?.longitude.toString() ??
              Storage.getValue(StringConstants.longitude).toString());
          isNannyDataLoading.value = false;
          update();
          updateNannyMarkers();
          Get.back();
        }
      }, retryFunction: getDashboardApi);
    } catch (e, s) {
      toast(msg: e.toString(), isError: true);
      isNannyDataLoading.value = false;
      printError(info: "Get dashboard data post  API ISSUE $s");
    }
  }

  /// SEARCH NANNY BY NAME
  _searchNannyByName({required String name}) {
    try {
      var body = {
        "name": name,
      };

      log('body of search api $body');
      _apiHelper.postApi(ApiUrls.userDashBoard, body).futureValue((value) {
        var res = CustomerHomeDashboardResponseModel.fromJson(value);

        if (res.response.toString() ==
            AppConstants.apiResponseSuccess.toString()) {
          log("response success");
          homeNannyList.value = res.data?.dataList ?? [];
          address.value = res.data?.address ?? '';
          latitude = double.parse(res.data?.latitude.toString() ??
              Storage.getValue(StringConstants.latitude).toString());
          longitude = double.parse(res.data?.longitude.toString() ??
              Storage.getValue(StringConstants.longitude).toString());
          isNannyDataLoading.value = false;

          update();
          updateNannyMarkers();
        }
      }, retryFunction: getDashboardApi);
    } catch (e, s) {
      toast(msg: e.toString(), isError: true);
      isNannyDataLoading.value = false;
      printError(info: "Get dashboard data post  API ISSUE $s");
    }
  }

  void searchNanny(String name) {
    debounce.call(() {
      _searchNannyByName(name: name.trim());
    });
  }

  redirectToGetNannyProfile() async {
    await Get.to(const GetNannyProfileView(), arguments: nannyUserId.value);
  }

  ///used to get final date with time
  DateTime returnFinalTimeAccordingToDate(
      {required DateTime? selectedTime, required DateTime day}) {
    if (selectedTime != null) {
      log('condition>>>>>>> ${selectedTime.hour != DateTime.now().hour}');
      return DateTime(
        day.year,
        day.month,
        day.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    } else {
      return DateTime.now();
    }
  }

  /// used for reset filters
  resetFilters() {
    distanceLowerValue = Dimens.zero;
    distanceHigherValue = 25;
    ageLowerValue = 13;
    ageHigherValue = 50;
    selectedGender = '';
    selectedDate = DateTime.now();
    selectedTime = DateTime.now();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getDashboardApi();
  }
}
