import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// service is used only when we need to not remove the controller from memory.
// class MyController extends GetxService {
class MyController extends GetxController {
// this is use only when we are using reactive state-management.
  var value = 0.obs;
  var value1 = 2.obs;
  addition() => value.value + value1.value;
  incrementReactive() {
    value++;
  }

  // this is use when we use simple state-management.
  var count = 0;

  increment() {
    count++;
    //this is use when we use simple state-management.
    update();
  }

  /// localization
  void changeLocalization(String language, String countryCode) {
    var local = Locale(language, countryCode);
    Get.updateLocale(local);
    update();
  }

  /// select date.
  DateTime? selectedDate;
  DateTime focusDay = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  rangeSelected(DateTime? start,DateTime? end,DateTime? focus){
   startDate=start;
    endDate=end;
    focusDay=focusDay;
    update();
   var value= DateFormat('yyyy/MM/dd').format(startDate ?? DateTime.now());
   var value1= DateFormat('yyyy/MM/dd').format(endDate ?? DateTime(DateTime.now().year-1));
   print('startDate:$value');
   print('endDate:$value1');
  }

  // check is same day
isSameDay(DateTime? selectedDay,DateTime day){
    if(selectedDate==day){
      return true;
    }else{
      return false;
    }
}

@override
  void onInit() {
    super.onInit();
    selectedDate=focusDay;
  }

  /// today of day
   TimeOfDay? startTime;
   TimeOfDay? endTime;
  apiMethod(){

  }

}
