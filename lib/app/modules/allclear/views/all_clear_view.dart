import 'dart:io';

import 'package:allclearer/app/data/setting_display_value_data.dart';
import 'package:allclearer/app/data/settings/setting_beep.dart';
import 'package:allclearer/app/data/settings/setting_display_value.dart';
import 'package:allclearer/app/data/settings/setting_heatbeat.dart';
import 'package:allclearer/app/data/settings/setting_screen_lighting.dart';
import 'package:allclearer/app/data/settings/setting_vib10.dart';
import 'package:allclearer/app/data/settings/setting_vib3.dart';
import 'package:allclearer/app/modules/allclear/widgets/display_values_container.dart';
import 'package:allclearer/app/modules/allclear/widgets/rxbool_visibility.dart';
import 'package:allclearer/app/ui/widgets/border_container.dart';
import 'package:allclearer/app/ui/widgets/app_button.dart';
import 'package:allclearer/app/ui/widgets/padding_column.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../ui/themes/app_colors.dart';
import '../../../ui/widgets/adaptive_wrap.dart';
import '../../../ui/widgets/use_app_banner.dart';
import '../controllers/all_clear_controller.dart';

class AllClearView extends GetView<AllClearController> {
  const AllClearView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.getPageTitle())),
        centerTitle: true,
        actions: [
          Obx(() => GestureDetector(
              onTap: () {
                controller.refreshDifference();
              },
              child: controller.isRefreshing()
                  ? const CircularProgressIndicator.adaptive()
                  : const Icon(CupertinoIcons.refresh_thick))),
          const SizedBox(width: 15)
        ],
      ),
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    SettingDisplayValueData dvData =
        controller.getSetting(SettingDisplayValue).getData();

    return Obx(() => Container(
        //duration: const Duration(milliseconds: 0),
        color: controller.getBackgroundColor(),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        child: Column(
          children: [
            getTimeArea(dvData),
            SizedBox(height: 10.h),
            Expanded(
                child: ListView(
              children: [
                AdaptiveWrap(children: [
                  Column(
                    children: [
                      getPreviewButton(),
                      const BorderContainer(
                          title: '📺화면',
                          body: '화면을 사용한 시각적 효과',
                          backgroundColor: AppColors.grey),
                      PaddingColumn(children: [
                        DisplayValuesContainer(data: dvData),
                        /*BorderContainer(
                      title: '밀리초(ms) 표시',
                      body: '밀리세컨드를 표시해요',
                      checkBox:
                          controller.getSetting(SettingMillisecond).getData()),*/
                        BorderContainer(
                            title: '붉은 섬광',
                            body: '3초 전부터 화면이 붉게 깜빡여요.',
                            checkBox: controller
                                .getSetting(SettingScreenLighting)
                                .getData()),
                      ]),
                      const BorderContainer(
                          title: '🔊소리',
                          body: '진동과 관련된 효과음',
                          backgroundColor: AppColors.grey),
                      PaddingColumn(children: [
                        BorderContainer(
                            title: '비프음',
                            body: '3초 전부터 비프음을 울려요.',
                            checkBox:
                                controller.getSetting(SettingBeep).getData()),
                      ]),
                    ],
                  ),
                  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                    Column(
                      children: [
                        const BorderContainer(
                            title: '📳진동',
                            body: '진동과 관련된 효과음',
                            backgroundColor: AppColors.grey),
                        PaddingColumn(
                          children: [
                            BorderContainer(
                                title: '심장박동',
                                body: '60bpm의 심장박동. 1초마다 약한 진동을 울려요.',
                                checkBox: controller
                                    .getSetting(SettingHeartbeat)
                                    .getData()),
                            BorderContainer(
                                title: '5초 전부터 진동',
                                body: '5초 전부터 중간 강도의 진동을 울려요.',
                                checkBox: controller
                                    .getSetting(SettingVib10)
                                    .getData()),
                            BorderContainer(
                                title: '3초 전부터 진동',
                                body: '3초 전부터 강한 진동을 울려요.',
                                checkBox: controller
                                    .getSetting(SettingVib3)
                                    .getData()),
                          ],
                        ),
                      ],
                    ),
                  Column(
                    children: [
                      const BorderContainer(
                          title: '🛠️기타',
                          body: '\'진짜\' 올클러가 되기 위한 옵션',
                          backgroundColor: AppColors.grey),
                      PaddingColumn(
                        children: [
                          BorderContainer(
                            title: '시간 앞당기기',
                            body:
                                '시간을 n밀리세컨드 더 빠르게 만들어요.\n이렇게 하면 손가락이 마우스를 클릭, 요청이 서버로 전송되면서 발생하는 지연시간까지 고려할 수 있어요.\n\n5ms = 0.005초\n10ms = 0.01초\n100ms = 0.1초\n1000ms = 1초',
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textEditingController: controller.fastForwardTEC,
                            textFieldHint: '0 ~ 1000 사이의 값 입력',
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
                const Divider(),
                Obx(() {
                  // 구독
                  controller.isRefreshing();

                  return Visibility(
                      visible: !controller.isPreviewMode(),
                      child: Center(
                        child: Text(
                          '고려된 지연 시간 : ${controller.getDelay() == null ? '로드 중' : (-controller.getDelay()!)}',
                          style: const TextStyle(color: AppColors.textBlueGrey),
                        ),
                      ));
                }),
                if (kIsWeb) const UseAppBanner(),
              ],
            ))
          ],
        )));
  }

  Widget getPreviewButton() {
    return Obx(() {
      bool isPreview = controller.isPreviewMode();
      Widget child;

      if (!isPreview) {
        child = AppButton(
            callback: () {
              controller.setPreviewMode(true);
            },
            text: '연습 모드 활성화 하기');
      } else {
        child = Shimmer.fromColors(
          baseColor: Colors.red,
          highlightColor: Colors.redAccent.shade100.withOpacity(0.5),
          child: GestureDetector(
            onTap: () {
              controller.setPreviewMode(false);
            },
            child: Container(
              height: 30.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textBlueGrey, width: 2),
                  borderRadius: BorderRadius.circular(12.r)),
              child: const Center(
                child: Text('연습모드 끄기'),
              ),
            ),
          ),
        );
      }

      return BorderContainer(
        title: '연습모드',
        body: '결정의 순간 1분 30초 전으로 이동합니다.',
        backgroundColor: Colors.blueGrey.shade50,
        child: child,
      );
    });
  }

  Widget getTimeArea(SettingDisplayValueData setting) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RxBoolVisibility(rx: setting.goal, child: getTargetTimeWidget()),
        RxBoolVisibility(
            rx: setting.day,
            child: Obx(() => Text("${controller.day}일",
                style: TextStyle(
                  fontSize: 15.spMin,
                )))),
        RxBoolVisibility(
            rx: setting.hour,
            child: Obx(() => Text("${controller.hour}시",
                style: TextStyle(
                  fontSize: 15.spMin,
                )))),
        RxBoolVisibility(
            rx: setting.minute,
            child: Obx(() => Text(
                  "${controller.minute}분",
                  style: TextStyle(
                      fontSize: 27.spMin, fontWeight: FontWeight.w700),
                ))),
        RxBoolVisibility(
            rx: setting.second,
            child: Obx(() => Text(
                  "${controller.second}초",
                  style: TextStyle(
                      fontSize: 30.spMin, fontWeight: FontWeight.w900),
                ))),
        RxBoolVisibility(
            rx: setting.millisecond,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Text("${controller.millisecond}ms")),
              ],
            ))
      ],
    );
  }

  Widget getTargetTimeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Shimmer.fromColors(
            baseColor: Colors.blueGrey,
            highlightColor: Colors.black12,
            child: RichText(
                text: TextSpan(
                    style: const TextStyle(
                        color: AppColors.grey, fontWeight: FontWeight.bold),
                    children: [
                  const TextSpan(text: '결정의 순간: '),
                  TextSpan(text: '${controller.goalStr}')
                  /*if (ot.minute != null) TextSpan(text: '${ot.minute}분 '),
                  if (ot.second != null) TextSpan(text: '${ot.second}초 '),
                  if (ot.minute == null && ot.second == null)
                    const TextSpan(text: '정각')*/
                ])))
      ],
    );
  }
}
