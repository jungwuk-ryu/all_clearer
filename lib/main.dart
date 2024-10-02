import 'package:allclearer/app/routes/my_route_observer.dart';
import 'package:allclearer/app/services/preset_setting_service.dart';
import 'package:allclearer/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Get.put(MyRouteObserver());
  Get.put(StorageService(prefs));
  Get.put(PresetSettingService());

  runApp(ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) {
      return GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [Get.find<MyRouteObserver>()],
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
                color: Colors.white, scrolledUnderElevation: 0)),
      );
    },
  ));
}
