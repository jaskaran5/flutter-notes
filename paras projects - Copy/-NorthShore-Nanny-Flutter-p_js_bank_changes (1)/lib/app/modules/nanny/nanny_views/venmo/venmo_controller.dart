import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:northshore_nanny_flutter/app/models/venom_detail_model.dart';
import 'package:northshore_nanny_flutter/app/res/constants/extensions.dart';
import 'package:northshore_nanny_flutter/app/utils/custom_toast.dart';
import 'package:northshore_nanny_flutter/app/utils/validators.dart';
import 'package:northshore_nanny_flutter/navigators/routes_management.dart';

import '../../../../data/api/api_helper.dart';
import '../../../../models/register_response_model.dart';
import '../../../../res/constants/api_urls.dart';
import '../../../../res/constants/app_constants.dart';
import '../../../../utils/app_utils.dart';

class VenmoController extends GetxController {
  ApiHelper apiHelper = ApiHelper.to;

  final userNameTextEditingController = TextEditingController();
  final guardianNameTextEditingController = TextEditingController();
  final phoneNumberTextEditingController = TextEditingController();

  /// venmo and guardian validator
  void venmoValidator({required bool isVenmo, required bool isFromEdit}) {
    if (isVenmo) {
      if (userNameTextEditingController.text.isNullOrEmpty) {
        toast(msg: 'Please enter your venmo user name.', isError: true);
      } else {
        addOrEditVenmoDetail(
            isVenmoDetails: isVenmo, isComeFromEdit: isFromEdit);
      }
    } else {
      bool isValidate = Validator.instance.guardianDetailValidator(
        guardianName: guardianNameTextEditingController.text.trim(),
        phoneNumber: phoneNumberTextEditingController.text.trim(),
        userName: userNameTextEditingController.text.trim(),
      );
      if (isValidate) {
        addOrEditVenmoDetail(
            isVenmoDetails: isVenmo, isComeFromEdit: isFromEdit);
      } else {
        toast(msg: Validator.instance.error, isError: true);
      }
    }
  }

  /// api used to store the data of venom and guardian details.
  Future<void> addOrEditVenmoDetail(
      {required bool isVenmoDetails, required bool isComeFromEdit}) async {
    try {
      if (!(await Utils.hasNetwork())) {
        return;
      }
      Map<String, dynamic> body;
      if (isVenmoDetails) {
        body = {
          'VenmoUserName': userNameTextEditingController.text.trim(),
          'IsVenmoDetails': isVenmoDetails,
        };
      } else {
        body = {
          'VenmoUserName': userNameTextEditingController.text.trim(),
          'GuardianName': guardianNameTextEditingController.text.trim(),
          'PhoneNumber': phoneNumberTextEditingController.text.trim(),
          'IsVenmoDetails': isVenmoDetails,
        };
      }

      debugPrint("body of venmo and guardian details :$body");

      apiHelper.postApi(ApiUrls.addOrEditVenmoDetails, body).futureValue(
          (value) async {
        printInfo(
            info:
                "Post venmo and guardian details Nanny profile response value $value");
        var response = RegisterModelResponseJson.fromJson(value);
        if (response.response == AppConstants.apiResponseSuccess) {
          if (isComeFromEdit) {
            Get.back();
          } else {
            RouteManagement.goToOffAllWaitingApprovalView();
          }
        } else {
          toast(msg: response.message.toString(), isError: true);
        }
      }, retryFunction: () {});
    } catch (e, s) {
      toast(msg: e.toString(), isError: true);
      printError(info: "post venmo and guardian details  Nanny  API ISSUE $s");
    }
  }

  /// api used to get the data of venom and guardian details.
  Future<void> getVenmoAndGuardianDetail() async {
    try {
      if (!(await Utils.hasNetwork())) {
        return;
      }

      apiHelper
          .postApi(
        ApiUrls.getVenmoAndGuardianDetails,
        null,
      )
          .futureValue((value) async {
        printInfo(
            info:
                "Get venmo and guardian details Nanny profile response value $value");
        var response = VenomDetailModel.fromJson(value);
        if (response.response == AppConstants.apiResponseSuccess) {
          userNameTextEditingController.text =
              response.data?.venmoUserName ?? '';
          guardianNameTextEditingController.text =
              response.data?.guardianName ?? '';
          phoneNumberTextEditingController.text =
              response.data?.phoneNumber ?? '';
          update();
        } else {
          toast(msg: response.message.toString(), isError: true);
        }
      }, retryFunction: () {});
    } catch (e, s) {
      toast(msg: e.toString(), isError: true);
      printError(info: "Get venmo and guardian details  Nanny  API ISSUE $s");
    }
  }
}
