import 'dart:convert';

import 'package:allclearer/app/data/settings/acsetting.dart';
import 'package:allclearer/app/data/settings/setting_vib10.dart';
import 'package:allclearer/app/data/settings/setting_vib3.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SettingHeartbeat extends ACSetting<RxBool> {
  final RxBool _data = RxBool(true);

  SettingHeartbeat() {
    _data.listen((p0) => save(json.encode(p0)));
  }

  @override
  RxBool getData() {
    return _data;
  }

  @override
  String getKey() {
    return 'heartbeat';
  }

  @override
  Future<void> tick(Duration leftTime) async {
    if (getData().isFalse) return;

    int sec = leftTime.inSeconds;
    if (sec < 11) {
      if (sec < 4) {
        SettingVib3 v3 = controller.getSetting(SettingVib3) as SettingVib3;
        if (v3.getData().isTrue) return;
      }

      SettingVib10 v10 = controller.getSetting(SettingVib10) as SettingVib10;
      if (v10.getData().isTrue) return;
    }

    HapticFeedback.lightImpact();
  }

  @override
  void loadFromStringData(String data) {
    bool value = bool.parse(data);
    _data.value = value;
  }
}