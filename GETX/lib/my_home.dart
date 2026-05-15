import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_x/api_wrapper.dart';
import 'package:get_x/cupertino.dart';
import 'package:get_x/employe_model.dart';
import 'package:get_x/my_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      counter++;
    });
  }

  /// dependency injection..

  // by using get.put for create instance once in whole app other wise i use it or not.
// permanent is use to create object permanently.
  // and tag use to create different objects.
  var controller = Get.put(MyController());

  // by using get.lazy put is only initialize or create when we use the instance or object .
  // fenix is like permanent.
  // var c= Get.lazyPut(() => MyController(),fenix: false);

  //it create different objects every time only when use the instance or object.
  //   var b = Get.create(() => MyController());

  // model api
  var employeeData = EmployeeModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    ApiWrapper().getData().then((value) {
      if (value != null) {
        setState(() {
          employeeData = value;
          log('data:${employeeData.data?.length}');
        });
      }

      return;
    }).onError((error, stackTrace) {
      log('error:$error');
    });
  }

  Widget bottomSheet({required String heading, required String description}) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(heading,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    )),
                InkWell(onTap: Get.back, child: Icon(Icons.close, size: 20)),
              ],
            ),
          ),
          Divider(color: Colors.black, height: 2),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(description,
                style: TextStyle(fontSize: 15, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                // using getX routing with simple.
                // Get.to(() => ReactiveStateManagement());
                Get.bottomSheet(
                  CustomCupertinoDateTimePicker(
                    dateTime: DateTime.now(),
                  ),
                  // bottomSheet(
                  //     heading: 'Driving',
                  //     description:
                  //         'dbkjsbbzbdhbzbsjdbbshcbjbdjbjbjcbjbdjhbjb\nvhjgvhjvjygjy\n'),
                  isScrollControlled: true,
                  ignoreSafeArea: false,
                  barrierColor: Colors.blueGrey.withOpacity(.2),
                  // Optional, set to true if you want a draggable bottom sheet
                );
              },
              child: const Text(
                'Go To Reactive class',
                style: TextStyle(color: Colors.deepOrange, fontSize: 30),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'How are You !'.tr,
              style: const TextStyle(color: Colors.deepOrange, fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Get.find<MyController>().changeLocalization('en', 'US');
              },
              child: const Text('english'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Get.find<MyController>().changeLocalization('hi', 'IN');
              },
              child: const Text('hindi'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Get.find<MyController>().changeLocalization('fr', 'FR');
              },
              child: const Text('french'),
            ),
            const Text(
              'API DATA',
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16.0),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 70),
                      child: const Icon(
                        Icons.account_circle,
                        size: 30,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    )),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: employeeData.data?.length,
                itemBuilder: (context, index) {
                  return Text(
                    employeeData.data?[index].employeeName ?? '',
                    style:
                        const TextStyle(color: Colors.deepOrange, fontSize: 30),
                  );
                },
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
