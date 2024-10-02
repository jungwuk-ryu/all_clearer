
import 'package:allclearer/app/data/all_clear_preset.dart';
import 'package:allclearer/app/data/time_set_page_arguments.dart';
import 'package:allclearer/app/routes/app_pages.dart';
import 'package:allclearer/app/services/storage_service.dart';
import 'package:allclearer/app/sync/time_sync.dart';
import 'package:get/get.dart';

class PresetListController extends GetxController {
  final StorageService storage = Get.find<StorageService>();
  final Map<TimeSync, RxString> _tsNameMap = {};
  final RxList<AllClearPreset> presets = RxList();
  final RxBool removeMode = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    _loadPresets();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _loadPresets() {
    List<AllClearPreset> list = storage.getPresetList().reversed.toList(growable: false);
    presets.clear();
    presets.addAll(list);
  }

  RxString getTimeSyncName(TimeSync ts) {
    RxString rxString = _tsNameMap[ts] ?? RxString("");
    _tsNameMap[ts] = rxString;

    _loadTimeSyncName(ts, rxString);
    return rxString;
  }

  Future<void> _loadTimeSyncName(TimeSync ts, RxString rx) async {
    rx.value = await ts.getName();
  }

  void onTapPreset(AllClearPreset preset) {
    storage.bringPresetToLast(preset);
    Get.offAndToNamed(Routes.TIME_SET, arguments: TimeSetPageArguments(preset));
  }

  Future<void> removePreset(AllClearPreset preset) async {
    await storage.removePreset(preset.name);
    presets.remove(preset);
  }

  bool isRemoveMode() {
    return removeMode.value;
  }
}
