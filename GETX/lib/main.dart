import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_x/calender_view.dart';
import 'package:get_x/simple_statemanagement_in_get_x.dart';
import 'package:get_x/translation.dart';

void main() {
  // for orientation we use .
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        defaultTransition: Transition.leftToRight,
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        translations: Translation(),
        getPages: [
          GetPage(
            name: '/Simple-State-Management',
            page: () => const SimpleStateManagement(),
          ),
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const Material(child: CalenderView())
        // const MyHomePage(title: 'Flutter simple class without get x'),
        );
  }
}
