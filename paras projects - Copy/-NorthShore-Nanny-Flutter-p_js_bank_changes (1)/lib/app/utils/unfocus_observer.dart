import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/// Used to close the keyboard when navigating to a new route and when going back.
class UnFocusObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _unFocusIfNeeded();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _unFocusIfNeeded();
  }

  /// Helper method to unfocus the keyboard if it is currently focused.
  void _unFocusIfNeeded() {
    if (Get.focusScope?.hasFocus == true) {
      Get.focusScope?.unfocus();
    }
  }
}
