import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_x/my_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderView extends StatelessWidget {
  const CalenderView({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<MyController>(
      init: MyController(),
      builder: (controller) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TableCalendar(
                focusedDay: controller.focusDay,
                calendarStyle: const CalendarStyle(
                  rangeHighlightColor: Colors.lightBlueAccent,
                  rangeStartDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  isTodayHighlighted: false,
                ),
                firstDay: DateTime.now(),
                sixWeekMonthsEnforced: true,
                lastDay: DateTime(DateTime.now().year + 5),
                rangeStartDay: controller.startDate,
                availableGestures: AvailableGestures.none,
                // onDaySelected: (selectedDay, focusedDay) {
                //   if(!controller.isSameDay(controller.selectedDate, selectedDay)) {
                //     controller.selectedDate = selectedDay;
                //     controller.focusDay=focusedDay;
                //   }
                //   controller.update();
                // },
                calendarFormat: CalendarFormat.month,
                // selectedDayPredicate: (day) => controller.isSameDay(controller.selectedDate, day),
                rangeEndDay: controller.endDate,
                rangeSelectionMode: RangeSelectionMode.toggledOn,
                onRangeSelected: controller.rangeSelected,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                controller.startTime = await showTimePicker(
                  context: Get.context!,
                  initialTime: controller.startTime != null
                      ? controller.startTime!
                      : TimeOfDay.now(),
                );
                print('value:${controller.startTime}');
                controller.update();
              },
              child: Container(
                height: 20,
                width: 100,
                color: Colors.yellow,
                child: Text(controller.startTime == null
                    ? 'Select start Time'
                    : '${controller.startTime?.hour.toString().padLeft(2, '0')}:${controller.startTime?.minute.toString().padLeft(2, '0')} ${controller.startTime?.period.name}'),
              ),
            ),
            const SizedBox(height: 10,),
            InkWell(
              onTap: () async {
                controller.endTime = (await showTimePicker(
                  context: Get.context!,
                  initialTime: controller.endTime != null
                      ? controller.endTime!
                      : TimeOfDay.now(),
                ));
                print('value:${controller.endTime}');
                controller.update();
              },
              child: Container(
                height: 20,
                width: 100,
                color: Colors.yellow,
                child: Text(controller.endTime == null
                    ? 'Select End Time'
                    : '${controller.endTime?.hour.toString().padLeft(2, '0')}:${controller.endTime?.minute.toString().padLeft(2, '0')} ${controller.endTime?.period.name}'),
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              // if(controller.endDate!=DateTime(DateTime.now().year-1)) {

                var value=DateTime(controller.startDate!.year,controller.startDate!.month,controller.startDate!.day,controller.startTime!.hour,controller.startTime!.minute).toUtc();
                var value1=DateTime(controller.endDate!.year,controller.endDate!.month,controller.endDate!.day,controller.endTime!.hour,controller.endTime!.minute).toUtc();
               print('value:$value');
               print('value1:$value1');
                print('final value start:${controller.startTime?.hour
                    .toString()}:${controller.startTime?.minute.toString()}');
                print('final value end :${controller.endTime?.hour
                    .toString()}:${controller.endTime?.minute.toString()}');
              // }
            }, child: const Text('add Availability'))
          ],
        );
      });
}
