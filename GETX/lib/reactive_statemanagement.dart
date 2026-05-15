import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_x/my_controller.dart';

class ReactiveStateManagement extends StatelessWidget {
  ReactiveStateManagement({super.key});
// this is use to create object or initialize the controller.
  var controller = Get.put(MyController());

  // this is reactive variable or observable variable . with .obs we are not change this value if i make final and give compile time error if update the value.
  var count = 0.obs;

  // simple way to define reactive variable. for this we change the value of final variable.
  final value = RxInt(10);

  // or
  final v = Rx<int>(0);

  // or
  Rx<int> v1 = Rx<int>(0);

// it is called dependency injection . we use this to crete or initialize the controller.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('reactive state-management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //  obx call when variable is change.
            Obx(
              () => Text(
                '$count,${v.value} ,${value.value},${v1.value}',
                // ''
                style: const TextStyle(color: Colors.amber, fontSize: 30),
              ),
            ),

            // using GetX the we need controller .
            GetX<MyController>(
              //this is use to initialize the controller or create object of controller.
              // init: MyController(),
              builder: (controller) => Text(
                'get x ${controller.value}',
                style: const TextStyle(color: Colors.amber, fontSize: 30),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Get.find<MyController>().value += 5;
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)),
              child: const Text(
                'perform addition',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                // name route
                // Get.toNamed('/Simple-State-Management');

                //// to send value with argument in name route.

                    await Get.toNamed('/Simple-State-Management?value=30');
                // print('route value :$previousValue');
                // using this only previous page route is deleted.
                //               Get.offNamed('/Simple-State-Management?value=30');

                // using this all previous routes are deleted
                // Get.offAllNamed('/Simple-State-Management?value=30');
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.amberAccent),
              ),
              child: const Text(
                'go To Simple-state-management',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          count++;
          v.value += 2;
          //final variable
          value.value--;
          v1.value += 3;

          // if obserable variable not chnage then we use.
          // v.refresh();
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add,
            size: 40.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
