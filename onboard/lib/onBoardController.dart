import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'enums.dart';

class OnBoardController extends GetxController {
  final textController = TextEditingController();

  var question = [
    {
      'question': 'What is Your name',
      'type': DataTypes.textField,
      'options': [],
      'answers': '',
    },
    {
      'question': 'What is Your Gender',
      'type': DataTypes.radioButton,
      'options': ['Male', 'Female', 'Other'],
      'answers': '',
    },
    {
      'question': 'What is Your Dob',
      'type': DataTypes.datePicker,
      'options': [],
      'answers': '',
    },
  ];

  var currentQuestion = 0;

  dynamic selectedValue;

  updateToNextQuestion() {
    if (currentQuestion < question.length - 1) {
      currentQuestion++;
    } else {
      question.map(
        (e) => print('answers:${e['answers']}'),
      );
      Get.dialog(
        Center(
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green,
              ),
              child: const Text('SuccessFully Submit your answers'),
            ),
          ),
        ),
      );
    }
    update();
  }

  /// used to store the values of answers
  storeAnswers(
    DataTypes type,
    int index,
  ) {
    var answer = '';
    if (type == DataTypes.textField) {
      answer = textController.text.trim();
    } else if (type == DataTypes.radioButton) {
      answer = selectedValue.toString();
    } else if (type == DataTypes.checkBox) {
      answer = selectedValue.toString();
    } else if (type == DataTypes.datePicker) {
      answer = selectedValue.toString();
    }
    print('answer:${answer.isNotEmpty}');
    if (answer.toString().isNotEmpty) {
      question[index]['answers'] = answer;
      answer = '';
      selectedValue = '';
      updateToNextQuestion();
    }
    update();
  }
}
