import 'dart:convert';

import '../sync/device_time_sync.dart';
import '../sync/ntp_time_sync.dart';
import '../sync/server_time_sync.dart';
import '../sync/time_sync.dart';

class AppUtil {
  static TimeSync getTimeSyncFromJson(String jsonStr) {
    Map data = json.decode(jsonStr);
    String id = data['id'];

    TimeSync ts;

    // TODO : 구조 개선 필요
    if (id == DeviceTimeSync.id) {
      ts = DeviceTimeSync();
    } else if (id == NTPTimeSync.id) {
      ts = NTPTimeSync("");
    } else if (id == ServerTimeSync.id) {
      ts = ServerTimeSync(Uri());
    } else {
      throw ArgumentError('invalid TimeSync data : $jsonStr');
    }

    ts.loadFromJson(jsonStr);

    return ts;
  }
}