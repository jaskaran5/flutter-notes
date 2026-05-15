import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:northshore_nanny_flutter/app/utils/app_utils.dart';
import 'package:northshore_nanny_flutter/app/utils/initializers.dart';
import 'package:northshore_nanny_flutter/app/utils/translations/translation_values.dart';
import 'package:northshore_nanny_flutter/app/utils/unfocus_observer.dart';
import 'package:northshore_nanny_flutter/navigators/app_pages.dart';

import 'app/data/notifications/firebase_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await FCMService().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Utils.checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        child: GetMaterialApp(
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver(), UnFocusObserver()],
          debugShowCheckedModeBanner: false,
          locale: const Locale('en'),
          theme: ThemeData(
            useMaterial3: false,
            scaffoldBackgroundColor: Colors.white,
          ),
          translations: TranslationsFile(),
          getPages: AppPages.pages,
          initialRoute: AppPages.initial,
          initialBinding: InitialBindings(),
        ),
      );
}
