import 'dart:convert';

import 'package:allclearer/app/data/settings/acsetting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreenLighting extends ACSetting<RxBool> {
  final RxBool _data = RxBool(true);


  SettingScreenLighting() {
    _data.listen((p0) => save(json.encode(p0)));
  }

  @override
  RxBool getData() {
    return _data;
  }

  @override
  String getKey() {
    return 'screen_lighting';
  }

  @override
  Future<void> tick(Duration leftTime) async {
    if (getData().isFalse) return;

    int sec = leftTime.inSeconds;
    if (sec < 5 && sec > 0) {
      if (sec == 1) {
        controller.lighting(Colors.green, delay: const Duration(milliseconds: 970));
      } else {
        controller.lighting(Colors.red, delay: const Duration(milliseconds: 970));
      }
    }
  }

  @override
  void loadFromStringData(String data) {
    bool value = bool.parse(data);
    _data.value = value;
  }
}