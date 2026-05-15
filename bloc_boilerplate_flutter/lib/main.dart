import 'package:bloc_boilerplate_flutter/config/helper.dart';
import 'package:bloc_boilerplate_flutter/core/utils/routing/routes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/helpers/app_injector.dart';
import 'core/utils/routing/routes_generator.dart';

void main() async {
  await AppInjector.init(appRunner: () => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      useInheritedMediaQuery: false,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: AppString.appName,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            child = botToastBuilder(context, child);
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child,
            );
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: false,
          ),
          initialRoute: Routes.splash,
          onGenerateRoute: RouteGenerator.generateRoute,
          onGenerateInitialRoutes: (String initialRouteName) {
            return [
              RouteGenerator.generateRoute(
                const RouteSettings(name: Routes.splash),
              ),
            ];
          },
        );
      },
    );
  }
}
