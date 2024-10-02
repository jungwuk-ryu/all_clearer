import 'dart:convert';
import 'dart:developer';

class OptionalTime {
  static const String _minuteKey = 'minute';
  static const String _secondKey = 'second';

  final int? minute;
  final int? second;

  const OptionalTime({
    this.minute,
    this.second,
  });

  factory OptionalTime.fromJson(String jsonStr) {
    try {
      Map data = json.decode(jsonStr);
      return OptionalTime(
          minute: int.tryParse('${data[_minuteKey]}'),
          second: int.tryParse("${data[_secondKey]}"));
    } catch (e, st) {
      log('There is an error (OptionalTime.fromJson)', error: e, stackTrace: st);
      return const OptionalTime();
    }
  }

  Duration getLeftTime(DateTime now) {
    DateTime target;
    int tm;
    int ts;
    if (minute == null && second == null) {
      // 정각 모드
      tm = 0;
      ts = 0;
    } else {
      // 정시 모드
      tm = minute ?? now.minute;
      ts = second ?? 0;
    }

    target = now.copyWith(minute: tm, second: ts);

    if (target.isBefore(now)) {
      // 이미 시간이 지났다면 다음 시간 구하기
      if (minute == null && second != null) {
        target = target.add(const Duration(minutes: 1));
      } else {
        target = target.add(const Duration(hours: 1));
      }
    }

    return target.difference(now);
  }

  String toJson() {
    Map<String, int?> map = {'minute': minute, 'second': second};

    return json.encode(map);
  }
}
