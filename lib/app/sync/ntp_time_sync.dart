import 'dart:convert';
import 'dart:developer';

import 'package:allclearer/app/sync/time_sync.dart';
import 'package:ntp/ntp.dart';

class NTPTimeSync extends TimeSync {
  static const String id = "ntp_time_sync";
  String server;

  NTPTimeSync(this.server);


  @override
  Future<Duration?> getDifference() async {
    try {
      // NTP 서버로부터 시간을 가져옴
      DateTime ntpTime = await NTP.now(lookUpAddress: server, timeout: const Duration(seconds: 5))..toUtc();
      final now = DateTime.now().toUtc();

      Duration diff = now.difference(ntpTime);
      return diff;
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  @override
  Future<String> getName() async {
    return server;
  }

  @override
  String getID() {
    return id;
  }

  @override
  void loadFromJson(String jsonStr) {
    dynamic data = json.decode(jsonStr);
    if (data == null || data.runtimeType != Map) {
      server = 'time.google.com';
    }

    server = data['server'] ?? 'time.google.com';
  }

  @override
  String toJson() {
    Map data = {
      'server': server,
      'id': getID()
    };

    return json.encode(data);
  }

}