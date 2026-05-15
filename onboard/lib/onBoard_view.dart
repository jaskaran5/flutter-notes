import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboard/enums.dart';

import 'onBoardController.dart';

class OnboardView extends StatelessWidget {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OnBoardController>(
          init: OnBoardController(),
          builder: (controller) {
            var question =
                controller.question[controller.currentQuestion]['question'];
            var type = controller.question[controller.currentQuestion]['type']
                as DataTypes;
            var options = controller.question[controller.currentQuestion]
                ['options'] as List;
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Text(
                      question.toString(),
                    ),
                  ),
                  if (type == DataTypes.textField) ...[
                    TextField(
                      controller: controller.textController,
                      onChanged: (value) {},
                    ),
                  ] else if (type == DataTypes.radioButton) ...[
                    ...List.generate(
                      options.length,
                      (index) {
                        return Row(
                          children: [
                            Radio<String>(
                              value: options[index].toString(),
                              groupValue: controller.selectedValue,
                              onChanged: (value) {
                                controller.selectedValue = value;
                                controller.update();
                              },
                            ),
                            Text('${options[index].toString()}')
                          ],
                        );
                      },
                    ),
                  ] else if (type == DataTypes.datePicker) ...[
                    InkWell(
                      onTap: () async {
                        DateTime? value = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (value != null) {
                          controller.selectedValue = value;
                          controller.update();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.lightBlueAccent,
                        ),
                        child: Text('Select Dob'),
                      ),
                    )
                  ],
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.storeAnswers(type, controller.currentQuestion);
                    },
                    child: Text('Submit'),
                  )
                ],
              ),
            );
          }),
    );
  }
}
