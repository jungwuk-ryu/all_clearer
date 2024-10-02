import 'package:get/get.dart';

import '../controllers/preset_list_controller.dart';

class PresetListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresetListController>(
      () => PresetListController(),
    );
  }
}
