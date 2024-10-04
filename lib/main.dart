import 'dart:ui';

import 'package:allclearer/app/routes/my_route_observer.dart';
import 'package:allclearer/app/services/preset_setting_service.dart';
import 'package:allclearer/app/services/storage_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';
import 'app/services/ad_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  /**
   * Initializing
   */
  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
    AdService as = Get.find<AdService>();
    as.showAppOpenAd();
  });

  Future firebaseFuture =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await firebaseFuture;

  /**
   * FirebaseCrashlytics
   */
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  /**
   * FirebaseAnalytics
   */
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  /**
   * 앱 시작
   */

  Get.put(MyRouteObserver());
  Get.put(StorageService(prefs));
  Get.put(PresetSettingService());
  Get.put(AdService());

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
        navigatorObservers: [
          Get.find<MyRouteObserver>(),
          FirebaseAnalyticsObserver(analytics: analytics)
        ],
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
                color: Colors.white, scrolledUnderElevation: 0)),
      );
    },
  ));
}
