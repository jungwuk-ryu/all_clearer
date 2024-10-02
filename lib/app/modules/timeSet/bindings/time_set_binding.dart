import 'package:get/get.dart';

import '../controllers/time_set_controller.dart';

class TimeSetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeSetController>(
      () => TimeSetController(),
    );
  }
}
