import 'package:allclearer/app/modules/allclear/bindings/all_clear_binding.dart';
import 'package:allclearer/app/modules/allclear/views/all_clear_view.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/presetList/bindings/preset_list_binding.dart';
import '../modules/presetList/views/preset_list_view.dart';
import '../modules/serverUrlInput/bindings/server_url_input_binding.dart';
import '../modules/serverUrlInput/views/server_url_input_view.dart';
import '../modules/timeSet/bindings/time_set_binding.dart';
import '../modules/timeSet/views/time_set_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ALL_CLEAR,
      page: () => const AllClearView(),
      binding: AllClearBinding(),
    ),
    GetPage(
      name: _Paths.TIME_SET,
      page: () => const TimeSetView(),
      binding: TimeSetBinding(),
    ),
    GetPage(
      name: _Paths.SERVER_URL_INPUT,
      page: () => const ServerUrlInputView(),
      binding: ServerUrlInputBinding(),
    ),
    GetPage(
      name: _Paths.PRESET_LIST,
      page: () => const PresetListView(),
      binding: PresetListBinding(),
    ),
  ];
}
