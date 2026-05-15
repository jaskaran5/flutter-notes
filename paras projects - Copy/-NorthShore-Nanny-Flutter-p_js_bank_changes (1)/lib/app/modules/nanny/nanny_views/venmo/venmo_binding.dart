import 'package:get/get.dart';
import 'package:northshore_nanny_flutter/app/modules/nanny/nanny_views/venmo/venmo_controller.dart';

class VenmoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VenmoController());
  }
}
