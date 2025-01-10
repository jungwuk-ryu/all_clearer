import 'package:allclearer/app/modules/allclear/controllers/all_clear_controller.dart';
import 'package:allclearer/app/services/storage_service.dart';
import 'package:get/get.dart';

abstract class ACSetting<T> {
  StorageService get storage => Get.find<StorageService>();
  AllClearController get controller => Get.find<AllClearController>();
  String _presetName = '';

  String getKey();

  T getData();

  Future<void> tick(Duration leftTime) async {}

  void load() {
    String? data = storage.getSettingData(_presetName, getKey());
    if (data == null) return;
    loadFromStringData(data);
  }

  void loadFromStringData(String data);

  Future<void> save(String data) async {
    await storage.saveSettingData(_presetName, getKey(), data);
  }

  void setPresetName(String prefix) {
    _presetName = prefix;
  }

  String get presetName => _presetName;
}