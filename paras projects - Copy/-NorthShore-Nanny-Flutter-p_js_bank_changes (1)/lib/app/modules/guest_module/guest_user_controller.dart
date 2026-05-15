import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:northshore_nanny_flutter/app/res/constants/extensions.dart';

import '../../data/api/api_helper.dart';
import '../../models/customer_home_dashboard_response_model.dart';
import '../../res/constants/api_urls.dart';
import '../../res/constants/app_constants.dart';
import '../../utils/app_utils.dart';
import '../../utils/custom_toast.dart';

class GuestUserControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestUserController>(() => GuestUserController());
  }
}

class GuestUserController extends GetxController {
  RxBool isNannyDataLoading = false.obs;
  final ApiHelper _apiHelper = ApiHelper.to;
  final searchTextEditingController = TextEditingController();

  RxList<NannyDataList> homeNannyList = <NannyDataList>[].obs;
  RxList<NannyDataList> searchedNannyList = <NannyDataList>[].obs;

  @override
  void onInit() {
    super.onInit();
    getDashboardApi();
  }

  Future<void> getDashboardApi() async {
    try {
      if (!(await Utils.hasNetwork())) {
        return;
      }
      Utils.loadingDialog();

      _apiHelper.postApi(ApiUrls.getNannyForGuest, {}).futureValue(
          (value) async {
        Utils.closeDialog();

        if (value['response'].toString() ==
            AppConstants.apiResponseSuccess.toString()) {
          homeNannyList.value = List<NannyDataList>.from(
              (value['data'] as List).map((v) => NannyDataList.fromJson(v)));

          isNannyDataLoading.value = false;
          update();
        } else {
          toast(msg: value["message"].toString(), isError: true);
          isNannyDataLoading.value = false;
          update();
        }
      }, retryFunction: getDashboardApi);
    } catch (e, s) {
      toast(msg: e.toString(), isError: true);
      isNannyDataLoading.value = false;
      printError(info: "Get dashboard data post  API ISSUE in GUEST $s");
    }
  }

  void searchNanny(String value) {
    isNannyDataLoading.value=true;
    update();
    if (value.isEmpty) {
      searchedNannyList.clear();
      searchTextEditingController.clear();
    } else {
      searchedNannyList.value = homeNannyList.where((nanny) {
        return nanny.name.toLowerCase().contains(value.toLowerCase());
      }).toList();
    }
    isNannyDataLoading.value=false;
    update();
  }
}
