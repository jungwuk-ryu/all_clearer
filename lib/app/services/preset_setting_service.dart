import 'package:allclearer/app/data/settings/acsetting.dart';
import 'package:allclearer/app/data/settings/setting_beep.dart';
import 'package:allclearer/app/data/settings/setting_display_value.dart';
import 'package:allclearer/app/data/settings/setting_fast_forward.dart';
import 'package:allclearer/app/data/settings/setting_heatbeat.dart';
import 'package:allclearer/app/data/settings/setting_screen_lighting.dart';
import 'package:allclearer/app/data/settings/setting_vib10.dart';
import 'package:allclearer/app/data/settings/setting_vib3.dart';
import 'package:allclearer/app/services/storage_service.dart';
import 'package:get/get.dart';

class PresetSettingService extends GetxService {
  final StorageService storage = Get.find<StorageService>();

  List<ACSetting> getAllSettings(String? presetName) {
    List<ACSetting> list = [
      SettingBeep(),
      SettingHeartbeat(),
      SettingScreenLighting(),
      SettingVib3(),
      SettingVib10(),
      SettingDisplayValue(),
      SettingFastForward()
    ];

    if (presetName != null) {
      for (ACSetting setting in list) {
        setting.setPresetName(presetName);
      }
    }

    return list;
  }
}