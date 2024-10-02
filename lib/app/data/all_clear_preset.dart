import 'dart:convert';

import 'package:allclearer/app/data/optional_time.dart';
import 'package:allclearer/app/sync/time_sync.dart';
import 'package:allclearer/app/utils/app_util.dart';

class AllClearPreset {
  String name;
  TimeSync ts;
  OptionalTime ot;

  AllClearPreset({required this.name, required this.ts, required this.ot});

  factory AllClearPreset.fromJson(String jsonStr) {
    Map data = json.decode(jsonStr);
    TimeSync ts = AppUtil.getTimeSyncFromJson(data['time_sync']);
    OptionalTime ot = OptionalTime.fromJson(data['time']);

    return AllClearPreset(name: data['name'] ?? '', ts: ts, ot: ot);
  }

  String toJson() {
    return json.encode({
      'name': name,
      'time_sync': ts.toJson(),
      'time': ot.toJson()
    });
  }
}