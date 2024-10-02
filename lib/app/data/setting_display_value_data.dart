import 'dart:convert';

import 'package:get/get.dart';

class SettingDisplayValueData {
  late RxBool goal;
  late RxBool day;
  late RxBool hour;
  late RxBool minute;
  late RxBool second;
  late RxBool millisecond;

  SettingDisplayValueData(
      bool goalV, bool dayV, bool hourV, bool minuteV, bool secondV, bool msV) {
    goal = RxBool(goalV);
    day = RxBool(dayV);
    hour = RxBool(hourV);
    minute = RxBool(minuteV);
    second = RxBool(secondV);
    millisecond = RxBool(msV);
  }

  factory SettingDisplayValueData.fromJson(String jsonData) {
    Map data = json.decode(jsonData);
    return SettingDisplayValueData(
        data['goal'] ?? true,
        data['day'] ?? true,
        data['hour'] ?? true,
        data['minute'] ?? true,
        data['second'] ?? true,
        data['ms'] ?? true);
  }

  String toJson() {
    Map<String, bool> data = {
      'goal': goal.value,
      'day': day.value,
      'hour': hour.value,
      'minute': minute.value,
      'second': second.value,
      'ms': millisecond.value
    };

    return json.encode(data);
  }

  void apply(SettingDisplayValueData data) {
    goal.value = data.goal.value;
    day.value = data.day.value;
    hour.value = data.hour.value;
    minute.value = data.minute.value;
    second.value = data.second.value;
    millisecond.value = data.millisecond.value;
  }

  void listenAnyUpdate(Function() callback) {
    goal.listen((p0) => callback());
    day.listen((p0) => callback());
    hour.listen((p0) => callback());
    minute.listen((p0) => callback());
    second.listen((p0) => callback());
    millisecond.listen((p0) => callback());
  }
}
