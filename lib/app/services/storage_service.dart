import 'dart:developer';

import 'package:allclearer/app/data/all_clear_preset.dart';
import 'package:allclearer/app/data/settings/acsetting.dart';
import 'package:allclearer/app/services/preset_setting_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static const String _recentHostListStorageKey =
      'server_url_input_recent_uri_list';
  static const String presetListKey = 'all_clear_preset_list';
  static String getPresetKey(String name) => 'all_clear_preset_$name';
  static String getLastTimeSetDataKey(String name) => 'time_set_last_data_$name';

  final SharedPreferences prefs;

  StorageService(this.prefs);

  List<String> getPresetNameList() {
    return prefs.getStringList(presetListKey) ?? [];
  }

  List<AllClearPreset> getPresetList() {
    List<AllClearPreset> ret = [];
    List<String> presetNameList = getPresetNameList();

    for (String name in presetNameList) {
      AllClearPreset? preset = getPreset(name);
      if (preset != null) ret.add(preset);
    }

    return ret;
  }

  AllClearPreset? getPreset(String name) {
    String? data = prefs.getString(getPresetKey(name));
    if (data == null) return null;

    return AllClearPreset.fromJson(data);
  }

  Future<void> removePreset(String name) async {
    List<String> list = getPresetNameList();
    list.remove(name);

    PresetSettingService settingService = Get.find<PresetSettingService>();
    for (ACSetting setting in settingService.getAllSettings(name)) {
      await removeSettingData(name, setting.getKey());
    }

    _setPresetList(list);
    await prefs.remove(getPresetKey(name));
  }

  Future<bool> _setPresetList(List<String> list) {
    return prefs.setStringList(presetListKey, list);
  }

  List<String> getRecentHostList() {
    List<String> data = prefs.getStringList(_recentHostListStorageKey) ?? [];
    return data;
  }

  Future<bool> setRecentHostList(List<String> list) {
    return prefs.setStringList(_recentHostListStorageKey, list);
  }

  Future<bool> savePreset(AllClearPreset preset) {
    return prefs.setString(getPresetKey(preset.name), preset.toJson());
  }

  Future<void> addPreset(AllClearPreset preset) async {
    List<String> nameList = getPresetNameList();
    nameList.add(preset.name);
    await _setPresetList(nameList);
    await prefs.setString(getPresetKey(preset.name), preset.toJson());
  }

  String getSettingStorageKey(String presetName, String settingKey) {
    return 'setting_${settingKey}_$presetName';
  }

  String? getSettingData(String presetName, String settingKey) {
    String key = getSettingStorageKey(presetName, settingKey);
    return prefs.getString(key);
  }

  Future<bool> saveSettingData(String presetName, String settingKey, String data) {
    String key = getSettingStorageKey(presetName, settingKey);
    log('saving($key) : $data');
    return prefs.setString(key, data);
  }

  Future<void> removeSettingData(String presetName, String settingKey) async {
    await prefs.remove(getSettingStorageKey(presetName, settingKey));
  }

  void bringPresetToLast(AllClearPreset preset) {
    List<String> nameList = getPresetNameList();
    nameList.remove(preset.name);
    nameList.add(preset.name);
    _setPresetList(nameList);
  }
}