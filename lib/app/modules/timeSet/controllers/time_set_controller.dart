import 'package:allclearer/app/data/all_clear_preset.dart';
import 'package:allclearer/app/data/optional_time.dart';
import 'package:allclearer/app/data/all_clear_page_arguments.dart';
import 'package:allclearer/app/data/time_set_page_arguments.dart';
import 'package:allclearer/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class TimeSetController extends GetxController {
  final StorageService storage = Get.find<StorageService>();
  final TextEditingController minTEC = TextEditingController();
  final TextEditingController secTEC = TextEditingController();
  final TextEditingController folderNameTEC = TextEditingController();
  final RxBool onTime = RxBool(false);
  final RxBool sharpTime = RxBool(true);
  final RxBool save = RxBool(false);

  late final TimeSetPageArguments arguments;
  late final AllClearPreset preset;

  @override
  void onInit() {
    super.onInit();
    arguments = Get.arguments;
    preset = arguments.preset;

    onTime.listen((p0) {
      if (p0) {
        sharpTime.value = false;
      } else if (sharpTime.isFalse) {
        onTime.value = true;
      }
    });

    sharpTime.listen((p0) {
      if (p0) {
        onTime.value = false;
      } else if (onTime.isFalse) {
        sharpTime.value = true;
      }
    });

    _loadLastData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _loadLastData() {
    OptionalTime data = preset.ot;
    int? second = data.second;
    int? minute = data.minute;

    if (second == null && minute == null) {
      sharpTime.value = true;
      onTime.value = false;
    } else {
      sharpTime.value = false;
      onTime.value = true;

      minTEC.text = minute != null ? '$minute' : '';
      secTEC.text = second != null ? "$second" : '';
    }
  }

  void nextPage() {
    String? name;

    if (save.isTrue) {
       name = folderNameTEC.text.trim();
      if (name.isEmpty) {
        Get.snackbar('올바르지 않은 올클 이름', '올클 이름을 입력해주세요.');
        return;
      }

      preset.name = name;
      if (!addPreset(preset)) return;
    }

    int? minuteV = int.tryParse(minTEC.text.trim());
    int? secondV = int.tryParse(secTEC.text.trim());

    if (onTime.isTrue) {
      if (minuteV == null && secondV == null) {
        Get.snackbar('정각 모드로 시작', '아무런 값을 입력하지 않아서 정각 알림 모드가 되었습니다.');
      } else { // 분, 초 값 유효성 확인
        if (minuteV != null && (minuteV < 0 || minuteV > 59)) {
          Get.snackbar('잘못된 값(분)', '유효한 값(0~59)를 입력하세요.');
          return;
        }

        if (secondV != null && (secondV < 0 || secondV > 59)) {
          Get.snackbar('잘못된 값(초)', '유효한 값(0~59)를 입력하세요.');
          return;
        }
      }
    } else {
      minuteV = null;
      secondV = null;
    }

    OptionalTime ot = OptionalTime(minute: minuteV, second: secondV);
    preset.ot = ot;
    storage.savePreset(preset);

    AllClearPageArguments allClearArguments = AllClearPageArguments(preset);
    Get.offAndToNamed(Routes.ALL_CLEAR, arguments: allClearArguments);
  }

  bool addPreset(AllClearPreset preset) {
    List<String> list = storage.getPresetNameList();
    if (list.contains(preset.name)) {
      Get.snackbar('다른 이름으로 다시 시도해주세요', '이미 존재하는 올클입니다.');
      return false;
    }

    storage.addPreset(preset);
    return true;
  }
}
