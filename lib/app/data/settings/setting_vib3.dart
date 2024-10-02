import 'dart:convert';

import 'package:allclearer/app/data/settings/acsetting.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SettingVib3 extends ACSetting<RxBool> {
  final RxBool _data = RxBool(true);


  SettingVib3() {
    _data.listen((p0) => save(json.encode(p0)));
  }

  @override
  getData() {
    return _data;
  }

  @override
  String getKey() {
    return 'vib3';
  }

  @override
  Future<void> tick(Duration leftTime) async {
    if (getData().isFalse) return;

    int sec = leftTime.inSeconds;
    if (sec < 4) {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void loadFromStringData(String data) {
    bool value = bool.parse(data);
    _data.value = value;
  }

}