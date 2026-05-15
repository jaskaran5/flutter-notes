import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:northshore_nanny_flutter/app/data/storage/storage.dart';
import 'package:northshore_nanny_flutter/app/res/constants/string_contants.dart';
import 'package:northshore_nanny_flutter/app/res/theme/colors.dart';
import 'package:northshore_nanny_flutter/app/res/theme/dimens.dart';
import 'package:northshore_nanny_flutter/app/res/theme/styles.dart';
import 'package:northshore_nanny_flutter/app/utils/custom_toast.dart';
import 'package:northshore_nanny_flutter/app/utils/dialog_utils.dart';
import 'package:northshore_nanny_flutter/app/widgets/app_text.dart';
import 'package:northshore_nanny_flutter/app/widgets/custom_inkwell_widget.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:permission_handler/permission_handler.dart';

import 'loading_dialog.dart';

class Utils {
  Utils._();

  static Future<bool> hasNetwork({bool? showToast}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var isSlow = await isInternetSlow;

    if (connectivityResult[0] != ConnectivityResult.wifi &&
        connectivityResult[0] != ConnectivityResult.mobile &&
        connectivityResult[0] != ConnectivityResult.ethernet &&
        isSlow) {
      toast(msg: "Please check your Internet Connection", isError: true);
      return false;
    } else {
      return true;
    }
  }

  /// used to listen the internet connectivity.
  static void checkInternetConnection() async {
    Connectivity().onConnectivityChanged.listen((event) async {
      log("<<<<<<<<<<<<<<<<<< Network Connection Type >>>>>>>>>>>>>>  ${event.toString()}");
      var isSlow = await isInternetSlow;
      if (event[0] != ConnectivityResult.wifi &&
          event[0] != ConnectivityResult.ethernet &&
          event[0] != ConnectivityResult.mobile &&
          isSlow) {
        Get.rawSnackbar(
          borderRadius: Dimens.ten,
          backgroundColor: AppColors.primaryColor,
          animationDuration: const Duration(seconds: 5),
          margin: Dimens.edgeInsets16,
          boxShadows: [
            BoxShadow(
              color: AppColors.hintColor.withValues(alpha: 0.3),
              blurRadius: Dimens.four,
              spreadRadius: Dimens.zero,
              offset: Offset(
                Dimens.zero,
                Dimens.two,
              ),
            )
          ],
          snackPosition: SnackPosition.BOTTOM,
          messageText: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: Dimens.edgeInsets8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.ten),
                          color: AppColors.fC3030RedColor.withValues(alpha: 0.2)),
                      child: const Icon(
                        Icons.error,
                        color: AppColors.fC3030RedColor,
                      ),
                    ),
                    Dimens.boxWidth10,
                    Flexible(
                      child: Text(
                        StringConstants.noInternet,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimens.fifteen,
                          fontWeight: FontWeight.w600,
                          color: AppColors.fC3030RedColor,
                        ),
                      ),
                    ),
                    Dimens.boxWidth10,
                  ],
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  /// used to check internet is slow or not.
  static Future<bool> get isInternetSlow async {
    try {
      final stopwatch = Stopwatch()..start();
      await InternetAddress.lookup(
          'example.com'); // Replace with a reliable address
      final duration = stopwatch.elapsedMilliseconds;
      return duration > 2000;
    } on SocketException catch (_) {
      return true; // Consider slow if lookup fails
    }
  }

  static bool emailValidation(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  static String getHeightsInInches(String height) {
    if (height.isNotEmpty) {
      List<String> splitList = height.runes.map((rune) {
        return String.fromCharCode(rune);
      }).toList();

      return "${splitList.first} feet | ${splitList.last} inches";
    } else {
      return "";
    }
  }

  static Future<void> showLoadingWithText({String? message}) async {
    BotToast.cleanAll();
    BotToast.showCustomLoading(
        useSafeArea: true,
        allowClick: false,
        clickClose: false,
        ignoreContentClick: true,
        align: Alignment.center,
        toastBuilder: (void Function() cancelFunc) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.five),
            ),
            margin: EdgeInsets.symmetric(horizontal: Dimens.sixty),
            child: Padding(
              padding: Dimens.edgeInsets10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: Dimens.fifty,
                    width: Dimens.fifty,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: AppColors.chatTimeColor,
                        valueColor: const AlwaysStoppedAnimation(
                            AppColors.primaryColor),
                        strokeWidth: Dimens.seven,
                      ),
                    ),
                  ),
                  Dimens.boxWidth32,
                  Expanded(
                      child: AppText(
                    text: message ?? "Please wait...",
                    textSize: Dimens.sixteen,
                    color: AppColors.blackColor,
                  ))
                ],
              ),
            ),
          );
        });
  }

  static void hideLoader() {
    BotToast.closeAllLoading();
  }

  static void printLog(dynamic log, {String tag = "log---->"}) {
    debugPrint("\n/***********\n\n $tag $log \n\n*************/\n");
  }

  static void hideKeyboard(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void loadingDialog() {
    closeDialog();

    Get.dialog(
      barrierDismissible: false,
      const Center(
          child: SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator())),
    );
  }

  static void closeDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  static void closeSnackbar() {
    if (Get.isSnackbarOpen == true) {
      Get.back();
    }
  }

  static void showSnackbar(String? message) {
    closeSnackbar();

    Get.rawSnackbar(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 16.0,
        ),
        borderColor: Colors.black,
        backgroundColor: AppColors.greenColor05B016,
        title: 'Alert',
        borderRadius: 20.0,
        messageText: AutoSizeText(
          message!,
        ),
        snackPosition: SnackPosition.TOP,
        forwardAnimationCurve: Curves.easeOutBack,
        duration: const Duration(seconds: 2));
  }

  static void showDialog(
    String? message, {
    String title = "error",
    bool success = false,
    VoidCallback? onTap,
  }) =>
      Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: () async {
          Get.back();

          onTap?.call();

          return true;
        },
        title: success ? "success" : title,
        content: Text(message ?? 'somethingWentWrong',
            textAlign: TextAlign.center,
            maxLines: 6,
            style: AppStyles.navyBlue15UbW600),
        confirm: Align(
          alignment: Alignment.centerRight,
          child: CustomInkwellWidget.text(
              onTap: () {
                Get.back();

                onTap?.call();
              },
              title: "Ok",
              textStyle: AppStyles.navyBlue15UbW600),
        ),
      );

  /// used to save the current lat long in Shared Preference.
  static Future<void> currentLocationSave() async {
    Utils.loadingDialog();
    try {
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy
            .bestForNavigation, //    forceAndroidLocationManager: true,
      ).then(
        (location) {
          Utils.closeDialog();
          Storage.saveValue(
              StringConstants.latitude, location.latitude.toString());
          Storage.saveValue(
              StringConstants.longitude, location.longitude.toString());
          debugPrint(location.latitude.toString());
          debugPrint(location.longitude.toString());
        },
      );
    } catch (e) {
      Utils.printLog('Catch Error >>>> $e');
      LoadingDialog.closeLoadingDialog();
      return;
    }
  }

  /// used to check the permission of location and open the dialog.
  static Future<bool?> getLocationPermissionStatus({String? title}) async {
    bool value = false;
    try {
      var status = await permission.Permission.location.status;
      debugPrint('Permission: $status');
      if (status != permission.PermissionStatus.granted) {
        var permissionStatus =
        await permission.Permission.location.request();
        Get.back();
        debugPrint('PermissionStatus: $permissionStatus');
        if (permissionStatus == permission.PermissionStatus.granted) {
          if (Storage.getValue(StringConstants.latitude)
              .toString()
              .isNotEmpty) {
            await currentLocationSave();
          }
          value = true;
        } else if (permissionStatus ==
            permission.PermissionStatus.denied) {
          value = false;
        } else if (permissionStatus ==
            permission.PermissionStatus.permanentlyDenied) {
          value = false;
          toast(
              msg:
              'Currently, your app\'s location service permission is set to " Permanent Denied". Please Enable it From App Settings.',
              isError: true);
        }
        // await DialogUtils.openLocationDialog(
        //     title: title.toString(),
        //     onAccept: () async {
        //       var permissionStatus =
        //           await permission.Permission.location.request();
        //       Get.back();
        //       debugPrint('PermissionStatus: $permissionStatus');
        //       if (permissionStatus == permission.PermissionStatus.granted) {
        //         if (Storage.getValue(StringConstants.latitude)
        //             .toString()
        //             .isNotEmpty) {
        //           await currentLocationSave();
        //         }
        //         value = true;
        //       } else if (permissionStatus ==
        //           permission.PermissionStatus.denied) {
        //         value = false;
        //       } else if (permissionStatus ==
        //           permission.PermissionStatus.permanentlyDenied) {
        //         value = false;
        //         toast(
        //             msg:
        //                 'Currently, your app\'s location service permission is set to " Permanent Denied". Please Enable it From App Settings.',
        //             isError: true);
        //       }
        //     });
      } else {
        value = true;
      }
      Utils.closeDialog();
      return value;
    } catch (e) {
      return false;
    }
  }
}
