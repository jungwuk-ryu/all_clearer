// ignore_for_file: unused_import

import 'dart:async';
import 'dart:io';

import 'package:allclearer/app/data/all_clear_preset.dart';
import 'package:allclearer/app/data/optional_time.dart';
import 'package:allclearer/app/routes/my_route_observer.dart';
import 'package:allclearer/app/services/storage_service.dart';
import 'package:allclearer/app/sync/time_sync.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/time_set_page_arguments.dart';
import '../../../routes/app_pages.dart';
import '../../../sync/device_time_sync.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  Timer? timer;
  RxString time = "".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    MyRouteObserver observer = Get.find<MyRouteObserver>();

    observer.addListener((route) {
      if (route == null) return;
      if (route.settings.name == Routes.HOME) {
        _setTimer();
      } else {
        _cancelTimer();
      }
    });

    _setTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _cancelTimer();
    } else if (state == AppLifecycleState.resumed) {
      _setTimer();
    }
  }

  void _cancelTimer() {
    timer?.cancel();
    timer = null;
  }

  void _setTimer() {
    _cancelTimer();
    timer = Timer.periodic(
        const Duration(milliseconds: 61), (timer) => _updateTime());
  }

  void _updateTime() {
    DateTime now = DateTime.now();
    time.value =
        "${now.year}.${now.month}.${now.day}. ${now.hour}시 ${now.minute}분 ${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}초";
  }

  Future<void> beep() async {
    FlutterBeep.playSysSound(iOSSoundIDs.KeyPressed1);
  }

  void toTimeSetPage(TimeSync ts) {
    StorageService storage = Get.find<StorageService>();
    AllClearPreset preset = storage.getPreset('') ?? AllClearPreset(name: '', ts: ts, ot: const OptionalTime());
    preset.ts = ts;
    Get.toNamed(Routes.TIME_SET, arguments: TimeSetPageArguments(preset));
  }
}
