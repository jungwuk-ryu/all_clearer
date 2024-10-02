import 'dart:convert';

import 'package:allclearer/app/sync/time_sync.dart';

class DeviceTimeSync extends TimeSync {
  static const String id = "device_time_sync";

  @override
  Future<Duration?> getDifference() async {
    return const Duration(milliseconds: -5);
  }

  @override
  Future<String> getName() async {
    return '기기 시간';
  }

  @override
  String getID() {
    return id;
  }

  @override
  void loadFromJson(String jsonStr) {
    return;
  }

  @override
  String toJson() {
    return json.encode({'id': getID()});
  }

}