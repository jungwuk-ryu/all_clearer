import 'dart:async';
import 'dart:developer';

import 'package:allclearer/app/data/optional_time.dart';
import 'package:allclearer/app/data/all_clear_page_arguments.dart';
import 'package:allclearer/app/data/settings/setting_fast_forward.dart';
import 'package:allclearer/app/services/preset_setting_service.dart';
import 'package:allclearer/app/sync/time_sync.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/settings/acsetting.dart';

class AllClearController extends GetxController with WidgetsBindingObserver {
  final RxInt day = RxInt(0);
  final RxInt hour = RxInt(0);
  final RxInt minute = RxInt(0);
  final RxInt second = RxInt(0);
  final RxInt millisecond = RxInt(0);

  final RxBool loading = RxBool(false);
  final Rx<Color> _backgroundColor = Rx(Colors.white);
  final Map<Type, ACSetting> _settings = {};
  late final String? presetName;

  late final AllClearPageArguments args;

  RxString goalStr = RxString("");

  late OptionalTime target;
  late TimeSync ts;
  final RxString _pageTitle = RxString("");

  final RxBool _isRefreshing = RxBool(false);
  final RxBool _isPreviewMode = RxBool(false);

  Duration? _differenceBak;
  TextEditingController fastForwardTEC = TextEditingController();
  Duration fastForward = const Duration();

  Duration? _difference;
  Timer? _timer;
  int _lastSecond = -1;

  @override
  void onInit() {
    super.onInit();

    args = Get.arguments;
    ts = args.preset.ts;
    target = args.preset.ot;
    presetName = args.preset.name;

    refreshDifference();
    _initSettings(presetName);
    _startTimer();
    loadPageTitle();

    fastForwardTEC.addListener(() {
     int v = int.tryParse(fastForwardTEC.text.trim()) ?? 0;
     if (v < 0) {
       fastForwardTEC.text = '0';
       v = 0;
     } else if (v > 1000) {
       fastForwardTEC.text = '1000';
       v = 1000;
     }

     fastForward = Duration(milliseconds: v);
     SettingFastForward setting = getSetting(SettingFastForward) as SettingFastForward;
     setting.getData().value = v;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      _startTimer();
    }
  }
  
  void _initSettings(String? folder) {
    PresetSettingService settingService = Get.find<PresetSettingService>();
    for (ACSetting setting in settingService.getAllSettings(folder)) {
      _settings[setting.runtimeType] = setting;
    }

    for (ACSetting setting in getSettings()) {
      setting.load();
    }

    dynamic data = getSetting(SettingFastForward).getData().value;
    if (data != null) {
      fastForwardTEC.text = '$data';
    }
  }

  Future<bool> refreshDifference() async {
    if (_isRefreshing.isTrue) return false;
    _isRefreshing.value = true;

    try {
      Duration? newDiff = await ts.getDifference();
      if (newDiff == null) {
        log("실패");
        Get.snackbar('불러오지 못함', '시간을 불러오지 못했습니다');
        return false;
      }

      _difference = newDiff;
      if (newDiff.inMinutes > 4) {
        Get.snackbar('주의', '기기 시간과 5분 이상 차이나요.');
      } else {
        Get.snackbar('시간을 정상적으로 불러옴', '서버와의 지연시간도 고려된 시간이에요.');
      }
      log('시간차 : $newDiff');
    } catch (e, st) {
      log('예외 발생', error: e, stackTrace: st);
      Get.snackbar('불러오지 못함', '시간을 불러오지 못했습니다(2)');
    } finally {
      _isRefreshing.value = false;
    }

    return true;
  }

  bool isRefreshing() {
    return _isRefreshing.value;
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _startTimer() {
    _stopTimer();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      _tick();
    });
  }

  void _tick() {
    if ( _difference == null) return;
    DateTime serverTime = DateTime.now().subtract(_difference! - fastForward);
    updateScreenTime(serverTime);
    int sec = serverTime.second;

    if (_lastSecond != sec) {
      _lastSecond = sec;
      Duration leftTime = target.getLeftTime(serverTime);
      for (ACSetting setting in getSettings()) {
        setting.tick(leftTime);
      }
      updateGoalStr(serverTime, leftTime);
    }
  }

  Future<void> updateGoalStr(DateTime serverTime, Duration leftTime) async {
    DateTime targetDt = serverTime.add(leftTime);

    final int rawHour = targetDt.hour;
    int hour = rawHour;
    bool isAM = false;

    if (rawHour > 12) {
      hour = rawHour - 12;
      isAM = false;
    }

    String newGoalStr = '${isAM ? '오전' : '오후'} $hour시 ${targetDt.minute}분 ${targetDt.second}초';
    if (goalStr.value != newGoalStr) goalStr.value = newGoalStr;
  }

  Future<void> updateScreenTime(DateTime dt) async {
    // 우선순위 순서로 배열
    second(dt.second);
    millisecond(dt.millisecond);
    minute(dt.minute);
    hour(dt.hour);
    day(dt.day);
  }

  Color getBackgroundColor() {
    return _backgroundColor.value;
  }

  Future<void> lighting(Color color, {Duration? delay}) async {
    if (delay != null) await Future.delayed(delay);
    _backgroundColor.value = color;
    await Future.delayed(const Duration(milliseconds: 300));
    _backgroundColor.value = Colors.white;
  }
  
  ACSetting getSetting(Type settingType) {
    return _settings[settingType]!;
  }

  Iterable<ACSetting> getSettings() {
    return _settings.values;
  }

  Future<void> loadPageTitle() async {
    if (presetName != null && presetName!.isNotEmpty) {
      _pageTitle.value = presetName!;
    } else {
      _pageTitle.value = await ts.getName();
    }
  }

  String getPageTitle() {
    return _pageTitle.value;
  }

  void setPreviewMode(bool enable) {
    if (enable) {
      if (_difference == null) {
        Get.snackbar('연습모드 이용 불가', '아직 시간이 로드되지 않았습니다.');
        return;
      }
      _differenceBak = _difference!;
      _difference = -target.getLeftTime(DateTime.now());
      _difference = _difference! + const Duration(minutes: 1, seconds: 30);
      log(_difference.toString());
      Get.snackbar('연습모드 활성화', '결정의 순간 1분 30초 전으로 왔습니다!');
      _pageTitle.value = '!! 연습모드 !!';
    } else {
      _difference = _differenceBak;
      _differenceBak = null;
      Get.snackbar('연습모드 꺼짐', '이제 실전입니다.');
      loadPageTitle();
    }
    _isPreviewMode.value = enable;
  }

  bool isPreviewMode() {
    return _isPreviewMode.value;
  }

  Duration? getDelay() {
    return _difference;
  }
}
