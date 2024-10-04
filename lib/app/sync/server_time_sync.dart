import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:allclearer/app/sync/time_sync.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;

class ServerTimeSync extends TimeSync {
  static const String id = 'server_time_sync';
  Uri uri;

  ServerTimeSync(this.uri);

  @override
  Future<Duration?> getDifference() async {
    final stopwatch = Stopwatch()..start();

    try {
      http.Client client = http.Client();
      http.Request req = http.Request('HEAD', uri);
      req.followRedirects = false;

      final response = await client.send(req);
      final String? serverTimeStr = response.headers['date'];

      if (serverTimeStr != null) {
        log("서버 시간 : $serverTimeStr");
        final DateTime serverTime = HttpDate.parse(serverTimeStr).toUtc();
        stopwatch.stop();

        final latency = stopwatch.elapsedMilliseconds ~/ 2;
        serverTime.add(Duration(milliseconds: latency + 10));
        final now = DateTime.now().toUtc();

        // 서버 시간에 지연 시간과 약간의 보정값 10ms 추가
        final difference = now.copyWith(millisecond: 0).difference(serverTime);

        log(difference.toString());
        return difference;
      }
    } catch (e, st) {
      log('$e', error: e, stackTrace: st);
      FirebaseCrashlytics.instance.recordError(e, st);
    }

    stopwatch.stop();
    return null;
  }

  @override
  Future<String> getName() async {
    return uri.host;
  }

  @override
  String getID() {
    return id;
  }

  @override
  void loadFromJson(String jsonStr) {
    try {
      uri = Uri.parse(json.decode(jsonStr)['uri'] ?? 'https://google.com');
    } catch (e, st) {
      log('error', error: e, stackTrace: st);
      uri = Uri.parse('https://google.com');
      FirebaseCrashlytics.instance.recordError(e, st);
    }
  }

  @override
  String toJson() {
    Map data = {
      'uri': uri.toString(),
      'id': getID()
    };

    return json.encode(data);
  }
}
