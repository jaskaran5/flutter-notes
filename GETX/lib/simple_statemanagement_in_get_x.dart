import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_x/my_controller.dart';

class SimpleStateManagement extends StatelessWidget {
  const SimpleStateManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'simple state-Management',
          style: TextStyle(fontSize: 20, color: Colors.deepOrange),
        ),
        leading: IconButton(
          onPressed: () {
            // this is use to get this value in previous route.
            Get.back(result: 20);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 40),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GetBuilder<MyController>(
            init: MyController(),
            builder: (controller) {
              return Text(
                '${controller.count}',
                style: const TextStyle(fontSize: 40, color: Colors.deepOrange),
              );
            },
          ),
          Text(
            Get.parameters['value'] ?? '',
            style: const TextStyle(fontSize: 40, color: Colors.deepOrange),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Get.find<MyController>().increment();
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
              color: Colors.orangeAccent, shape: BoxShape.circle),
          child: const Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
