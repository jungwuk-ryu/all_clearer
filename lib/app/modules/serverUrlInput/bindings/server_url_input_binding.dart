import 'package:get/get.dart';

import '../controllers/server_url_input_controller.dart';

class ServerUrlInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServerUrlInputController>(
      () => ServerUrlInputController(),
    );
  }
}
