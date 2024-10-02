import 'package:allclearer/app/data/setting_display_value_data.dart';
import 'package:allclearer/app/data/settings/acsetting.dart';

class SettingDisplayValue extends ACSetting<SettingDisplayValueData> {
  final SettingDisplayValueData _data = SettingDisplayValueData(true, true, true, true, true, true);


  SettingDisplayValue() {
    _data.listenAnyUpdate(() {
      save(_data.toJson());
    });
  }

  @override
  SettingDisplayValueData getData() {
    return _data;
  }

  @override
  String getKey() {
    return 'display_value';
  }

  @override
  void loadFromStringData(String data) {
    _data.apply(SettingDisplayValueData.fromJson(data));
  }
}