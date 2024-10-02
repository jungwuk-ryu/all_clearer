import 'package:allclearer/app/data/settings/acsetting.dart';
import 'package:get/get.dart';

class SettingFastForward extends ACSetting<RxnInt> {
  final RxnInt _data = RxnInt();

  SettingFastForward() {
    _data.listen((p0) => save('${_data.value}'));
  }

  @override
  RxnInt getData() {
    return _data;
  }

  @override
  String getKey() {
    return 'fast_forward';
  }

  @override
  void loadFromStringData(String data) {
    _data.value = int.tryParse(data);
  }

}