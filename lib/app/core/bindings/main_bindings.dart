import 'package:allclearer/app/services/ad_service.dart';
import 'package:allclearer/app/services/preset_setting_service.dart';
import 'package:allclearer/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBindings extends Bindings {
  final SharedPreferences prefs;

  MainBindings(this.prefs);

  @override
  void dependencies() {
    Get.put(StorageService(prefs));
    Get.put(PresetSettingService());
    Get.put(AdService());
  }
}
