import 'dart:convert';

import 'package:allclearer/app/data/settings/acsetting.dart';
import 'package:allclearer/app/services/app_sound_service.dart';
import 'package:get/get.dart';

class SettingBeep extends ACSetting<RxBool> {
  final RxBool _data = RxBool(true);
  final AppSoundService _soundService = Get.find<AppSoundService>();

  SettingBeep() {
    _data.listen((p0) => save(json.encode(p0)));
  }

  @override
  getData() {
    return _data;
  }

  @override
  String getKey() {
    return 'beep';
  }

  @override
  Future<void> tick(Duration leftTime) async {
    if (getData().isFalse) return;

    int sec = leftTime.inSeconds;
    if (sec < 5 && sec > 0) {
      if (sec == 1) {
        _soundService.beep(SoundFile.beep880, delay: const Duration(milliseconds: 900));
      } else {
        _soundService.beep(SoundFile.beep440, delay: const Duration(milliseconds: 900));
      }
    }
  }

  @override
  void loadFromStringData(String data) {
    bool value = bool.parse(data);
    _data.value = value;
  }

}