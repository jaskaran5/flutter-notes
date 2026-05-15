import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:northshore_nanny_flutter/app/data/storage/storage.dart';
import 'package:northshore_nanny_flutter/app/models/location_lat_long_model.dart';
import 'package:northshore_nanny_flutter/app/modules/auth/customer/customer_views/create_profile/create_customer_profile_controller.dart';
import 'package:northshore_nanny_flutter/app/modules/nanny/nanny_views/create_profile/create_nanny_profile_controller.dart';
import 'package:northshore_nanny_flutter/app/res/constants/string_contants.dart';
import 'package:northshore_nanny_flutter/app/res/theme/dimens.dart';
import 'package:northshore_nanny_flutter/app/utils/app_utils.dart';
import 'package:permission_handler/permission_handler.dart' as pl;

class GoogleMapViewController extends GetxController {
  RxBool isFromEdit = false.obs;

  final searchLocationTextEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  Rx<LatLng> currentLatLng = Rx(const LatLng(0.0, 0.0));

  GoogleMapController? googleMapController;

  @override
  void onInit() {
    searchLocationTextEditingController.clear();

    isFromEdit.value = Get.arguments ?? false;

    log("-----isfromEdit--->>>. ${isFromEdit.value}");
    update();
    super.onInit();
  }

  updateCurrentPosition({required double latitude, required double longitude}) {
    currentLatLng.value = LatLng(latitude, longitude);
    log('Current  long >>>>>>>>> $currentLatLng');
    update();
  }

  /// used to get current location in map view .
  Future<Position?> getUserLocation() async {
    Position? position;
    var permission = await Utils.getLocationPermissionStatus(
        title:
            'App needs your location for map updates and real-time nanny tracking. This ensures accurate service and safety. You can decline, but some features may not work properly.');

    // Check location permission
    log('permission Status :$permission ');
    var permissionStatus = await pl.Permission.location.status;
    log('permission Status 1====================:$permissionStatus ');
    if (((permission != null && permission == true)) ||
        (permissionStatus == pl.PermissionStatus.granted)) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    }
    // Get user's current position

    return position;
  }

  initializeGoogleMapController(
      {required GoogleMapController controller}) async {
    googleMapController = controller;
    log('>>>>>>>>>> map Created>>>>>>>>>>>>>>>>');
    await getUserLocation().then((value) async {
      log("location position is:-->> $value");
      if (value != null) {
        googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 15,
            ),
          ),
        );
      }
      await updateCurrentPosition(
        latitude: value?.latitude ?? 0.0,
        longitude: value?.longitude ?? 0.0,
      );
    });
    update();
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placeMarks[0];
      String formattedAddress =
          "${place.name},${place.locality},${place.subLocality}  ${place.administrativeArea} ${place.postalCode} ${place.country}";

      return formattedAddress;
    } catch (e) {
      log("Error: $e");
      return '';
    }
  }

  /// used to get city and state from the coordinates.
  Future<Map<String, String>> getCityStateFromCoordinates(
      {required double latitude, required double longitude}) async {
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placeMarks[0];

      /// locality is city and administrativeArea is state
      String city = "${place.locality}";
      String state = "${place.administrativeArea}";
      Map<String, String> address = {
        'city': city,
        'state': state,
      };
      log('city and state >>>>>>>>>>> $address');
      return address;
    } catch (e) {
      log("Error: $e");
      return {};
    }
  }

  updateIsFromEdit({required bool isFrom}) {
    isFromEdit.value = isFrom;
    log('isFrom Edit :$isFrom   >>>>>>> ${currentLatLng.value}');
    searchLocationTextEditingController.clear();
    update();
  }

  saveLocationCoordinates() async {
    var logInType = await Storage.getValue(StringConstants.loginType);
    String address = '';
    log('current lat long values >>>>>>${currentLatLng.value}');
    address = await getAddressFromCoordinates(
      currentLatLng.value.latitude,
      currentLatLng.value.longitude,
    );
    var value = await getCityStateFromCoordinates(
      latitude: currentLatLng.value.latitude,
      longitude: currentLatLng.value.longitude,
    );
    var city = value['city'].toString();
    var state = value['state'].toString();
    log('address >>>>>> $address   ${searchLocationTextEditingController.text}  lat long $currentLatLng  $city  $state');

    if (logInType == StringConstants.customer) {
      Get.find<CreateCustomerProfileController>()
          .updateLocationTextField(
        position: searchLocationTextEditingController.text.isNotEmpty
            ? searchLocationTextEditingController.text
            : address,
        lat: currentLatLng.value.latitude.toString(),
        long: currentLatLng.value.longitude.toString(),
        cityAddress: city,
        stateAddress: state,
      )
          .then((value) {
        Get.back();
      });
    } else if (logInType == StringConstants.nanny) {
      Get.find<CreateNannyProfileController>()
          .updateLocationTextField(
        formatAddress: searchLocationTextEditingController.text.isNotEmpty
            ? searchLocationTextEditingController.text
            : address,
        lat: currentLatLng.value.latitude.toString(),
        long: currentLatLng.value.longitude.toString(),
        cityAddress: city,
        stateAddress: state,
      )
          .then((value) {
        Get.back();
      });
    }
  }

  Future<LocationLatLongModel> getEditLocation() async {
    var address = await getAddressFromCoordinates(
        currentLatLng.value.latitude != 0.0
            ? currentLatLng.value.latitude
            : Storage.getValue(StringConstants.latitude),
        currentLatLng.value.longitude != 0.0
            ? currentLatLng.value.longitude
            : Storage.getValue(StringConstants.longitude));

    var values = await getCityStateFromCoordinates(
      longitude: currentLatLng.value.longitude != 0.0
          ? currentLatLng.value.longitude
          : Storage.getValue(StringConstants.longitude),
      latitude: currentLatLng.value.latitude != 0.0
          ? currentLatLng.value.latitude
          : Storage.getValue(StringConstants.latitude),
    );
    var getCity = values['city'];
    var getState = values['state'];
    log('edit city and state >>>>>>>>> $getCity  $getState');
    return LocationLatLongModel(
      latitude: currentLatLng.value.latitude.toString(),
      longitude: currentLatLng.value.longitude.toString(),
      location: searchLocationTextEditingController.text.isEmpty
          ? address
          : searchLocationTextEditingController.text,
      city: getCity,
      state: getState,
    );
  }

  /// used to get location on based on search .
  updateCameraPositionOfMapBySearch(
      {required String lat, required String lon}) async {
    if (lat.isNotEmpty && lat != 'null' || lon.isNotEmpty && lon != 'null') {
      var latitude = double.parse(lat);
      var longitude = double.parse(lon);
      log('lat long update:$latitude  , $longitude');
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: Dimens.ten,
          ),
        ),
      );
      currentLatLng.value = LatLng(latitude, longitude);
    }
    update();
  }
}
