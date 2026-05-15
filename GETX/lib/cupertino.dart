import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomCupertinoDateTimePicker extends StatefulWidget {
  const CustomCupertinoDateTimePicker({
    super.key,
    this.bufferTime,
    this.dateTime,
  });

  final num? bufferTime;
  final DateTime? dateTime;

  @override
  State<CustomCupertinoDateTimePicker> createState() =>
      _CustomCupertinoDateTimePickerState();
}

class _CustomCupertinoDateTimePickerState
    extends State<CustomCupertinoDateTimePicker> {
  Timer? timer;
  DateTime? dateTime;
  DateTime? cupertinoDateTime;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    startInit();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        bottomSheet: Container(
          // padding: Dimens.edgeInsets16_0_16_0.copyWith(
          //   bottom: Dimens.bottomHeight,
          // ),
          color: Colors.white,
          // child: TextButton(

          //   // height:44,
          //   // width:100,
          //   // title: 'save',
          //   // onPress: () async {
          //   //   Get.back<DateTime>(result: cupertinoDateTime);
          //   // },
          // ),
        ),
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${dateTime == null || isTodayDate(dateTime) ? 'Today},' : ''} ${DateFormat('MMMM d - h:mm a').format(dateTime ?? DateTime.now())}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.yellow,
                ),
              ),
              const Divider(),
              SizedBox(
                height: 600,
                width: 346,
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      tabLabelTextStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                      ),
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    minuteInterval: 1,
                    backgroundColor: Colors.yellow,
                    minimumDate:
                        isTodayDate(dateTime) ? dateTime : DateTime.now(),
                    initialDateTime: dateTime,
                    use24hFormat: false,
                    maximumDate: DateTime((dateTime?.year ?? 0) + 100, 12, 31),
                    minimumYear: dateTime?.year ?? 0,
                    maximumYear: (dateTime?.year ?? 0) + 100,
                    onDateTimeChanged: (value) async {
                      cupertinoDateTime = value;
                    },
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      );

  //checks whether given date is today's date or not
  bool isTodayDate(DateTime? dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final newDate =
        DateTime(dateTime?.year ?? 0, dateTime?.month ?? 0, dateTime?.day ?? 0);
    return newDate == today;
  }

  void startInit() {
    dateTime = widget.dateTime ?? DateTime.now();
    cupertinoDateTime = widget.dateTime ?? DateTime.now();
    timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) async {
        dateTime = widget.dateTime ?? DateTime.now();
        setState(() {});
      },
    );
  }
}
