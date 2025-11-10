import 'package:allclearer/app/ui/widgets/border_container.dart';
import 'package:allclearer/app/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/time_set_controller.dart';

class TimeSetView extends GetView<TimeSetController> {
  const TimeSetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시간 설정'),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: _body()),
    );
  }

  Widget _body() {
    DateTime now = DateTime.now();
    return Column(
      children: [
        Expanded(
            child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              BorderContainer(
                  title: '🕒정각 알림',
                  body: '매시간 0분 0초를 목표로 설정합니다.\n예시 : ${now.hour}시 00분 00초',
                  checkBox: controller.sharpTime),
              BorderContainer(
                  title: '🗓️정시 알림',
                  body:
                      '특정 시간 (n분 n초)를 목표로 설정합니다.\n예시: ${now.minute}분 ${now.second}초',
                  checkBox: controller.onTime),
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Obx(() => Visibility(
                    visible: controller.onTime.isTrue,
                    maintainAnimation: true,
                    maintainState: true,
                    child: AnimatedOpacity(
                      opacity: controller.onTime.isTrue ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BorderContainer(
                            title: '분(minute)',
                            body: '입력하지 않을 경우 \'매분\'으로 설정됩니다.',
                            textFieldHint: '선택 사항',
                            textEditingController: controller.minTEC,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                          BorderContainer(
                            title: '초(second)',
                            body: '입력하지 않을 경우 \'0초\'로 설정됩니다.',
                            textFieldHint: '선택 사항',
                            textEditingController: controller.secTEC,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          )
                          //Spacer(),
                        ],
                      ),
                    ))),
              ),
              SizedBox(height: 15.h),
            ])),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const Spacer(),
                  if (controller.preset.name.isEmpty)
                    Obx(
                      () => BorderContainer(
                        title: '저장하기',
                        body: '홈 화면의 \'내가 만든 올클\'에서 확인할 수 있어요.',
                        checkBox: controller.save,
                        textFieldHint: '올클 이름 입력',
                        textEditingController: controller.save.isTrue
                            ? controller.folderNameTEC
                            : null,
                      ),
                    ),
                ],
              ),
            ),
          ],
        )),
        AppButton(callback: () => controller.nextPage(), text: '다음'),
        SizedBox(height: 20.h)
      ],
    );
  }
}
