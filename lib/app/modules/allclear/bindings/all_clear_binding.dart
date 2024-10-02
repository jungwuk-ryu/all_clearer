import 'package:allclearer/app/services/app_sound_service.dart';
import 'package:get/get.dart';

import '../controllers/all_clear_controller.dart';

class AllClearBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllClearController>(
      () => AllClearController(),
    );
    Get.put(AppSoundService());
  }
}
