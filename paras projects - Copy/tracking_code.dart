import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:northshore_nanny_flutter/app/models/booking_details_model.dart';
import 'package:northshore_nanny_flutter/app/models/booking_status_model.dart';
import 'package:northshore_nanny_flutter/app/modules/common/rating_and_review/rating_and_review_binding.dart';
import 'package:northshore_nanny_flutter/app/modules/common/rating_and_review/rating_and_review_controller.dart';
import 'package:northshore_nanny_flutter/app/modules/common/socket/singnal_r_socket.dart';
import 'package:northshore_nanny_flutter/app/modules/nanny/nanny_views/nanny_home/nanny_home_binding.dart';
import 'package:northshore_nanny_flutter/app/modules/nanny/nanny_views/nanny_home/nanny_home_controller.dart';
import 'package:northshore_nanny_flutter/app/res/constants/extensions.dart';
import 'package:northshore_nanny_flutter/app/res/theme/dimens.dart';
import 'package:northshore_nanny_flutter/navigators/app_routes.dart';
import 'package:northshore_nanny_flutter/navigators/routes_management.dart';

import '../../../../data/api/api_helper.dart';
import '../../../../models/nanny_booking_details.dart';
import '../../../../res/constants/api_urls.dart';
import '../../../../res/constants/app_constants.dart';
import '../../../../res/constants/assets.dart';
import '../../../../res/constants/enums.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/custom_toast.dart';
import '../../../../utils/utility.dart';
import '../../../common/dashboard_bottom/dashboard_bottom_binding.dart';
import '../../../common/dashboard_bottom/dashboard_bottom_controller.dart';
import '../../../common/notification/notification_binding.dart';
import '../../../common/notification/notification_controller.dart';

class NannyBookingDetailController extends GetxController {
  final ApiHelper _apiHelper = ApiHelper.to;

  /// used to initiate socket
  final SignalRHelper socketHelper = SignalRHelper();

  NannyBookingDetailStatus? nannyBookingDetailStatus;
  Timer? timer;
  int seconds = 0;
  // Polyline? nannyPolyLine;
  BookingDetailsModel? bookingDetailsModel;

  // RxBool isArrivedButtonEnable = false.obs;

  /// used to check google map controller is Initialize or not
  bool isGoogleControllerInitialize = false;

  /// used to show the start time.
  showTimer({required DateTime startTime}) {
    log('Timer data in nanny side $startTime');
    seconds = 0;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds = DateTime.now().difference(startTime).inSeconds;
      update(['timerView']);
    });
  }

  /// report list
  var reportList = [
    'Unavailable for this day/time',
    'Job is too far away',
    'Other'
  ];

  @override
  void dispose() {
    super.dispose();
    seconds = 0;
    timer?.cancel();
    // googleMapController?.dispose();
  }

  /// used to click on back from the booking detail screen.
  void onBackPress() {
    if (Get.currentRoute == Routes.dashboard) {
      /// used to initialize the NannyHomeController  if not .
      if (!Get.isRegistered<NannyHomeController>()) {
        NannyHomeBinding().dependencies();
      }

      /// used to call the api when going back from nanny booking details view.
      Get.find<NannyHomeController>().getHomeData();
    }

    /// used to initialize the DashboardBottomController  if not .
    if (!Get.isRegistered<DashboardBottomController>()) {
      DashboardBottomBinding().dependencies();
    }
    if (Get.find<DashboardBottomController>().selectedTabIndex.value == 2) {
      /// used to get notification counts.
      Get.find<DashboardBottomController>().getNotificationCount();

      /// used to initialize the NotificationController  if not .
      if (!Get.isRegistered<NotificationController>()) {
        NotificationBinding().dependencies();
      }

      /// api call to get notification updated list.
      Get.find<NotificationController>().getNotificationList();
    }

    Get.back();
    Get.delete<NannyBookingDetailController>();
  }

  /// used to store the rejected reason.
  String? rejectionReason;

  /// used to store the other rejection
  final otherRejectionTextEditingController = TextEditingController();

  /// selected index store for report dialog
  int? selectedIndex;

  /// method which is used to return the type of booking.
  typeOfBooking({required int bookingStatus}) {
    if (bookingStatus == 1) {
      nannyBookingDetailStatus = NannyBookingDetailStatus.present;
    } else if (bookingStatus == 2) {
      nannyBookingDetailStatus = NannyBookingDetailStatus.onMyWay;
      // getCurrentLocation();
    } else if (bookingStatus == 3) {
      nannyBookingDetailStatus = NannyBookingDetailStatus.rejected;
    } else if (bookingStatus == 4) {
      nannyBookingDetailStatus = NannyBookingDetailStatus.arrived;
    } else if (bookingStatus == 5) {
      nannyBookingDetailStatus = NannyBookingDetailStatus.endJob;
    } else if (bookingStatus == 6) {
      nannyBookingDetailStatus = NannyBookingDetailStatus.waitingForApproval;
      seconds = 0;
      timer?.cancel();
      update(['timerView']);
    } else if (bookingStatus == 7) {
      nannyBookingDetailStatus = NannyBookingDetailStatus.approvedByAdmin;
    } else if (bookingStatus == 8) {
      nannyBookingDetailStatus = NannyBookingDetailStatus.disputeRaised;
    } else if (bookingStatus == 9) {
      nannyBookingDetailStatus = NannyBookingDetailStatus.givenReviewByCustomer;
    }
    log('Booking Status Nanny Side :$bookingStatus');
    update();
  }

  /// accept or reject booking detail
  acceptOrRejectBookingDetail(
      {required int bookingId,
      required int bookingStatus,
      int? rejectionStatus,
      String? rejectionReason}) async {
    try {
      if (!(await Utils.hasNetwork())) {
        return;
      }
      var body = {
        "bookingId": bookingId,
        "status": bookingStatus,
        "rejectReasonStatus": rejectionStatus,
        "utcDatetTime": DateTime.now().toUtc().toIso8601String(),
        "rejectReason": rejectionReason,
      };
      debugPrint('Accept or reject body:${body.toString()}');
      _apiHelper
          .postApi(
        ApiUrls.acceptOrRejectBooking,
        jsonEncode(body),
      )
          .futureValue((value) {
        printInfo(
            info:
                "  Nanny accept or reject  booking dates in nanny booking details $value");
        var response = NannyBookingDetails.fromJson(value);
        if (response.response == AppConstants.apiResponseSuccess) {
          getBookingDetailOfCustomer(bookingId: bookingId);
          update();
        } else {
          toast(msg: response.message.toString(), isError: true);
        }
      }, retryFunction: () {});
    } catch (e, s) {
      toast(msg: e.toString(), isError: true);
      printError(info: "Nanny accept or reject   post  API ISSUE $s");
    }
  }

  /// update status
  updateStatus({
    required int bookingId,
    required int bookingStatus,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    try {
      if (!(await Utils.hasNetwork())) {
        return;
      }
      var body = {
        "bookingId": bookingId,
        "status": bookingStatus,
        if (startTime != null)
          "utcStartTime": startTime.toUtc().toIso8601String(),
        if (endTime != null) "utcEndTime": endTime.toUtc().toIso8601String(),
      };
      log('update status body -> $body');
      _apiHelper
          .postApi(
        ApiUrls.updateBookingStatus,
        jsonEncode(body),
      )
          .futureValue((value) {
        printInfo(info: "Update booking status $value");
        var response = BookingStatusModel.fromJson(value);
        if (response.response == AppConstants.apiResponseSuccess) {
          log('booking Type-:${response.data?.bookingStatus}');
          if (response.data?.bookingStatus == 6) {
            showTimer(
              startTime: DateTime.now(),
            );
          }
          getBookingDetailOfCustomer(bookingId: response.data?.bookingId ?? 0);
          update(['timerView']);
        } else {
          toast(msg: response.message.toString(), isError: true);
        }
      }, retryFunction: () {});
    } catch (e, s) {
      toast(msg: e.toString(), isError: true);
      printError(info: "update booking status  API ISSUE $s");
    }
  }

  /// get booking details of customer
  Future<void> getBookingDetailOfCustomer({required int bookingId}) async {
    try {
      if (!(await Utils.hasNetwork())) {
        return;
      }
      var body = {
        "bookingId": bookingId,
        "currentUtcTime": DateTime.now().toUtc().toIso8601String(),
      };
      debugPrint('body of booking details:$body');

      _apiHelper
          .postApi(
        ApiUrls.customerBookedNannyDetail,
        jsonEncode(body),
      )
          .futureValue((value) async {
        var response = BookingDetailsModel.fromJson(value);
        if (response.response == AppConstants.apiResponseSuccess) {
          bookingDetailsModel = response;
          update();
          typeOfBooking(bookingStatus: response.data?.bookingStatus ?? 0);
          if (response.data?.bookingStatus == 5) {
            showTimer(
              startTime: DateTime.now().add(
                Duration(
                  seconds: Utility.calculateDifferenceInSeconds(
                      response.data?.startTime ?? DateTime.now()),
                ),
              ),
            );
            // update();
          }
          if (response.data?.bookingStatus == 7) {
            seconds == 0;
            timer?.cancel();
            update(['timerView']);
            Future.delayed(const Duration(seconds: 4));
            Utility.showDialog(
              title: 'Congratulations! ',
              assetName: Assets.imagesStar,
              subTitle: 'Please rate your experience with this family!',
              buttonTitleText: 'Rate Now',
              assetWidth: Dimens.ninety,
              assetHeight: Dimens.hundredTen,
              titleMaxLine: 1,
              subTitleMaxLine: 1,
              onTapButton: () {
                Utility.closeDialog();
                if (!Get.isRegistered<RatingAndReviewController>()) {
                  RatingAndReviewBinding().dependencies();
                }
                Get.find<RatingAndReviewController>().storeUserData(
                  name: bookingDetailsModel?.data?.userDetails?.name ?? '',
                  image: bookingDetailsModel?.data?.userDetails?.image ?? '',
                  userReviews:
                      bookingDetailsModel?.data?.userDetails?.reviewCount ?? 0,
                  toUserId: bookingDetailsModel?.data?.userDetails?.userId ?? 0,
                  bookedId: bookingDetailsModel?.data?.bookingId ?? 0,
                  userRating:
                      bookingDetailsModel?.data?.userDetails?.rating ?? 0.0,
                  userGender:
                      bookingDetailsModel?.data?.userDetails?.gender == 1
                          ? ', M'
                          : bookingDetailsModel?.data?.userDetails?.gender == 2
                              ? ', F'
                              : '',
                );
                RouteManagement.goToRatingReviewScreen();
              },
              isImage: true,
              showCrossSvg: true,
            );
          }

          // await _getAlwaysAllowLocation();
          // addPolyLine(
          //     currentPosition: currentPosition, bookingDetailsModel: response);
        } else {
          toast(msg: response.message.toString(), isError: true);
        }
        update();
      }, retryFunction: () {});
      //
    } catch (e, s) {
      toast(msg: e.toString(), isError: true);
      printError(
          info: "Customer book nanny Customer details get  API ISSUE $s");
    }
  }

  /// ------------------- Tracking things start here --------------------
  ///
  /// used to initialize google Map
  // GoogleMapController? googleMapController;

  // void onMapCreated(GoogleMapController controller) async {
  //   googleMapController = controller;
  //   isGoogleControllerInitialize = true;
  //   update(['tracking']);
  // }

  /// current position
  // Position? currentPosition;

  /// used to stop the tracking and enable
  // StreamSubscription<Position>? locationStream;

  /// Start the tracking code .
  // Future<void> _startService() async {
  //   LocationSettings locationSettings = const LocationSettings();
  //
  //   if (Platform.isAndroid) {
  //     locationSettings = AndroidSettings(
  //         accuracy: LocationAccuracy.bestForNavigation,
  //         distanceFilter: 10,
  //         forceLocationManager: false,
  //         // intervalDuration: const Duration(seconds: 5),
  //         foregroundNotificationConfig: const ForegroundNotificationConfig(
  //             notificationText: "Location is being used for navigation",
  //             notificationTitle: "The Northshore Nanny",
  //             enableWakeLock: true,
  //             setOngoing: true,
  //             notificationIcon: AndroidResource(name: "@mipmap/ic_launcher")));
  //   } else if (Platform.isIOS) {
  //     locationSettings = AppleSettings(
  //         accuracy: LocationAccuracy.bestForNavigation,
  //         activityType: ActivityType.automotiveNavigation,
  //         distanceFilter: 10,
  //         // timeLimit: const Duration(seconds: 5),
  //         showBackgroundLocationIndicator: false,
  //         allowBackgroundLocationUpdates: true);
  //   } else {
  //     locationSettings = const LocationSettings(
  //       accuracy: LocationAccuracy.bestForNavigation,
  //       distanceFilter: 10,
  //       // timeLimit: Duration(seconds: 5),
  //     );
  //   }
  //   log('nanny Booking Status  :$nannyBookingDetailStatus and ${(nannyBookingDetailStatus == NannyBookingDetailStatus.onMyWay || nannyBookingDetailStatus == NannyBookingDetailStatus.arrived)}');
  //   if ((nannyBookingDetailStatus == NannyBookingDetailStatus.onMyWay ||
  //           nannyBookingDetailStatus == NannyBookingDetailStatus.arrived) &&
  //       bookingDetailsModel?.data?.openingDate?.isSameDate(DateTime.now()) ==
  //           true) {
  //     final distance = Geolocator.distanceBetween(
  //       double.parse(bookingDetailsModel?.data?.latitude ?? '0.0'),
  //       double.parse(bookingDetailsModel?.data?.longitude ?? '0.0'),
  //       double.parse(bookingDetailsModel?.data?.userDetails?.latitude ?? '0.0'),
  //       double.parse(
  //           bookingDetailsModel?.data?.userDetails?.longitude ?? '0.0'),
  //     );
  //
  //     log('distance>>>>>>>>>>>>>>>>>>>> $distance');
  //     if (distance <= 10.0) {
  //       isArrivedButtonEnable.value = true;
  //       update();
  //     } else {
  //       locationStream =
  //           Geolocator.getPositionStream(locationSettings: locationSettings)
  //               .listen((Position? position) async {
  //         log('-----------------------position --- $position -------------------> ');
  //         if (position != null) {
  //           currentPosition = position;
  //           log("**************** POSITION :  -->> ${currentPosition!.latitude},${currentPosition!.longitude}");
  //           final distance = Geolocator.distanceBetween(
  //             position.latitude,
  //             position.longitude,
  //             double.parse(
  //                 bookingDetailsModel?.data?.userDetails?.latitude ?? '0.0'),
  //             double.parse(
  //                 bookingDetailsModel?.data?.userDetails?.longitude ?? '0.0'),
  //           );
  //
  //           log('distance>>>>>>>>>>>>>>>>>>>> $distance');
  //           if (distance <= 50.0) {
  //             isArrivedButtonEnable.value = true;
  //             update();
  //
  //           /// used to send the data according to lat long.
  //           updateLatLong(
  //               toUserId: bookingDetailsModel?.data?.userDetails?.userId ?? 0,
  //               bookingId: bookingDetailsModel?.data?.bookingId ?? 0,
  //               latitude: position.latitude,
  //               longitude: position.longitude);
  //
  //           /// used to add poly Line according to the road or route.
  //           addPolyLine(
  //             currentPosition: currentPosition,
  //             bookingDetailsModel: bookingDetailsModel,
  //           );
  //
  //           /// used to animate the controller based on lat long.
  //           googleMapController
  //               ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //             target: LatLng(position.latitude, position.longitude),
  //             // zoom: 10
  //           )));
  //           log('-----------------------tracking on -------------------> ');
  //         }
  //
  //         update(['tracking-view']);
  //       });
  //     }
  //   } else if (nannyBookingDetailStatus ==
  //           NannyBookingDetailStatus.waitingForApproval ||
  //       nannyBookingDetailStatus == NannyBookingDetailStatus.endJob) {
  //     locationStream?.pause();
  //     locationStream?.cancel();
  //     log('-----------------------tracking off -------------------> ');
  //   }
  //   update(['tracking-view']);
  // }

  /// check the permission status for background .
  // Future<void> _getAlwaysAllowLocation() async {
  //   final location = await permission.Permission.location.status;
  //   if (location.isGranted) {
  //     _startService();
  //   } else {
  //     DialogUtils.openLocationDialog(
  //         onAccept: () async {
  //           var res = await permission.Permission.location.request();
  //           Get.back();
  //           if (res.isGranted) {
  //             _startService();
  //           } else {
  //             toast(
  //                 msg:
  //                     "This app requires location services for Tracking. Please enable location services in your device app settings.",
  //                 isError: true);
  //             _startService();
  //             log("Always allow location is denied");
  //           }
  //         },
  //         title:
  //             'Enabling location services is essential for starting tracking on the Northshore Nanny App. This allows our nannies to efficiently move to customer locations and ensures an optimal tracking experience. Please enable location services to enhance your service journey.');
  //   }
  // }

  /// used to get current location
  // Future<bool?> getLocationPermissionStatus() async {
  //   try {
  //     var permissionStatus = await permission.Permission.location.request();
  //     if (permissionStatus == permission.PermissionStatus.granted) {
  //       return true;
  //     } else if (permissionStatus == permission.PermissionStatus.denied) {
  //       return false;
  //     } else if (permissionStatus ==
  //         permission.PermissionStatus.permanentlyDenied) {
  //       return false;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  /// socket method which is use to update the  lat long
  // updateLatLong({
  //   required int toUserId,
  //   required int bookingId,
  //   required double latitude,
  //   required double longitude,
  // }) async {
  //   log('latitude:${latitude.toString()} ,longitude:${longitude.toString()} ,  bookingId:$bookingId, toUserId:$toUserId');
  //
  //   await socketHelper.hubConnection.invoke('TrackNanny', args: [
  //     toUserId,
  //     bookingId,
  //     latitude.toString(),
  //     longitude.toString(),
  //   ]);
  //   log('lat long sent');
  // }

  /// used  for create poly Line with the road by route.
  // addPolyLine(
  //     {required Position? currentPosition,
  //     required BookingDetailsModel? bookingDetailsModel}) async {
  //   var fistCoordinate = LatLng(
  //       currentPosition?.latitude ??
  //           double.parse(bookingDetailsModel?.data?.latitude ?? '0.0'),
  //       currentPosition?.longitude ??
  //           double.parse(bookingDetailsModel?.data?.longitude ?? '0.0'));
  //   var secondCoordinate = LatLng(
  //       double.parse(bookingDetailsModel?.data?.userDetails?.latitude ?? '0.0'),
  //       double.parse(
  //           bookingDetailsModel?.data?.userDetails?.longitude ?? '0.0'));
  //   nannyPolyLine =
  //       await setPolylineDirection(fistCoordinate, secondCoordinate);
  //   update(['tracking-view']);
  // }


/// used to return the polyLine according to origin and designation.
  static setPolylineDirection(LatLng origin, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];

    log("polyline :${origin.latitude}");
    log("polyline :${destination.longitude}");
    final result = await DirectionHelper().getRouteBetweenCoordinates(
        origin.latitude,
        origin.longitude,
        destination.latitude,
        destination.longitude);
    log("result.toString()---->${result.toString()}");
    if (result.isNotEmpty) {
      for (PointLatLng point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      return Polyline(
        polylineId: const PolylineId('line'),
        color: AppColors.navyBlue3288DE,
        points: polylineCoordinates,
        width: 6,
        startCap: Cap.squareCap,
        endCap: Cap.roundCap,
      );
    }
  }

}



import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:northshore_nanny_flutter/app/res/constants/string_contants.dart';

class DirectionHelper {
  final client = http.Client();

  Future<List<PointLatLng>> getRouteBetweenCoordinates(double originLat,
      double originLong, double destLat, double destLong) async {
    List<PointLatLng> polylinePoints = [];
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLong&destination=$destLat,$destLong&mode=driving&avoid=tolls&key=${StringConstants.googleApiKey}";

    var response = await http.get(Uri.parse(url));
    try {
      log(response.body.toString());
      if (response.statusCode == 200) {
        if ((json.decode(response.body)["routes"] as List).isNotEmpty) {
          polylinePoints = decodeEncodedPolyline(
              json.decode(response.body)["routes"][0]["overview_polyline"]
                  ["points"]);
        }
      }
    } catch (error) {
      throw Exception(error.toString());
    }
    // print(polylinePoints);
    return polylinePoints;
  }

  List<PointLatLng> decodeEncodedPolyline(String encoded) {
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      PointLatLng p =
          PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}

class PointLatLng {
  /// Creates a geographical location specified in degrees [latitude] and
  /// [longitude].
  ///
  const PointLatLng(this.latitude, this.longitude);

  /// The latitude in degrees.
  final double latitude;

  /// The longitude in degrees
  final double longitude;

  @override
  String toString() {
    return "lat: $latitude / longitude: $longitude";
  }
}

