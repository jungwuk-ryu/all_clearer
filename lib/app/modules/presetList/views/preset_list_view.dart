import 'package:allclearer/app/data/all_clear_preset.dart';
import 'package:allclearer/app/ui/widgets/border_container.dart';
import 'package:allclearer/app/ui/widgets/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../ui/themes/app_colors.dart';
import '../controllers/preset_list_controller.dart';

class PresetListView extends GetView<PresetListController> {
  const PresetListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 올클'),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: _body()),
    );
  }

  Widget _body() {
    return Column(
      children: [
        const BorderContainer(
          title: '💾저장된 올클 목록',
          body: '올클의 설정은 개별적으로 관리됩니다.',
          backgroundColor: AppColors.grey,
        ),
        Expanded(
            child: Obx(() => Visibility(
                  visible: controller.presets.isNotEmpty,
                  replacement:
                      const Column(
                        children: [BorderContainer(
                          title: '새로운 올클을 추가해주세요',
                            body: '저장된 올클이 없어요! \n홈 화면에서 시계를 선택하고 나만의 올클을 만들어보세요!')],
                      ),
                  child: Column(
                    children: [
                      BorderContainer(title: '삭제 버튼 보이기', checkBox: controller.removeMode),
                      Expanded(child: _listView())
                    ],
                  ),
                )))
      ],
    );
  }

  Widget _listView() {
    return Obx(() => ListView.builder(
          itemCount: controller.presets.length,
          itemBuilder: (BuildContext context, int index) {
            AllClearPreset preset = controller.presets[index];
            return GestureDetector(
              onTap: () => controller.onTapPreset(preset),
              child: Obx(() => BorderContainer(
                title: preset.name,
                body: controller.getTimeSyncName(preset.ts).value,
                child: !controller.isRemoveMode() ? null : Column(
                  children: [
                    SizedBox(height: 15.h),
                    NormalButton(callback: () {
                      controller.removePreset(preset);
                    }, text: '삭제')
                  ],
                ),
              )),
            );
          },
        ));
  }
}
