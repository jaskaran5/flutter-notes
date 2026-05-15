import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:theme/pages/splash.dart';
import 'package:theme/size_config.dart';
import 'package:theme/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);

            return GetMaterialApp(
              theme: AppTheme().getTheme(),
              supportedLocales: const [
                Locale('ar', 'SA'),
                Locale('de', 'DE'),
                Locale('en', 'US'),
                Locale('es', 'ES'),
                Locale('fr', 'FR'),
                Locale('hi', 'IN'),
                Locale('pt', 'BR')
              ],
              debugShowCheckedModeBanner: false,
              home: const SplashView(),
            );
          },
        );
      },
    );
  }
}
