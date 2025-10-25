import 'package:allclearer/app/modules/home/controllers/home_controller.dart';
import 'package:allclearer/app/services/app_sound_service.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.put(AppSoundService());
  }
}
