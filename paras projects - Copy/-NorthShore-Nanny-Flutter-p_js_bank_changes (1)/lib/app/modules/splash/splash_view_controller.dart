import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:northshore_nanny_flutter/app/data/storage/storage.dart';
import 'package:northshore_nanny_flutter/app/res/constants/string_contants.dart';
import 'package:northshore_nanny_flutter/navigators/routes_management.dart';

import '../common/socket/singnal_r_socket.dart';

class SplashController extends GetxController {
  RxBool isLogin = false.obs;

  // late AppLinks _appLinks;
  @override
  void onInit() {
    SignalRHelper().init();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// used to initialize socket .
    super.onInit();

    startOnInit();
  }

  checkSession() {

      if (Storage.hasData(StringConstants.isLogin)) {
        if (Storage.getValue(StringConstants.isLogin)) {
          RouteManagement.goToOffAllDashboard(isFromSetting: false);
        }
      } else {
        RouteManagement.goChooseBabySitter();
      }

  }

  saveDeviceTypeAndToken() async {
    if (GetPlatform.isAndroid) {
      Storage.saveValue(StringConstants.deviceType, 'android');
    } else if (GetPlatform.isIOS) {
      Storage.saveValue(StringConstants.deviceType, 'ios');
    }
  }

  void startOnInit() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    /*   _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onApp stream Link: $uri');
    });*/
    //_handleDeepLinking();
    saveDeviceTypeAndToken();
    checkSession();
  }

/*  void _handleDeepLinking() {
    const delayDuration = Duration(seconds: 3);
    Future.delayed(delayDuration, () async {
      final appLink = await _appLinks.getInitialLink();

      if (appLink != null) {
        RouteManagement.goToOffAllLogIn();
      }
    });
  }*/
}
