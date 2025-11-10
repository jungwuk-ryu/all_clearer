import 'package:allclearer/app/sync/device_time_sync.dart';
import 'package:allclearer/app/sync/ntp_time_sync.dart';
import 'package:allclearer/app/ui/widgets/adaptive_wrap.dart';
import 'package:allclearer/app/ui/widgets/app_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../routes/app_pages.dart';
import '../../../ui/themes/app_colors.dart';
import '../../../ui/widgets/border_container.dart';
import '../../../ui/widgets/padding_column.dart';
import '../../../ui/widgets/use_app_banner.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('올클러'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: _body(),
      )),
    );
  }

  Widget _body() {
    return ListView(
      children: [
        Center(
          child: Shimmer.fromColors(
              baseColor: Colors.blueGrey,
              highlightColor: Colors.black12,
              child: Obx(() => Text(
                    '${controller.time}',
                    style: GoogleFonts.nanumGothicCoding(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ))),
        ),
        const BorderContainer(
            title: '📖올클러 - 앱 소개',
            body:
                '이 앱은 시각적, 촉각적, 청각적 효과들로 티켓팅, 수강신청 등을 성공하도록 도와주는 앱이에요.\n아래의 목록에서 원하는 시계를 선택해보세요!'),
        BorderContainer(
          title: '내가 만든 올클',
          body: '직접 저장한 올클 목록을 확인할 수 있어요',
          child: AppButton(
              callback: () {
                Get.toNamed(Routes.PRESET_LIST);
              },
              text: '저장된 올클 목록'),
        ),
        AdaptiveWrap(
          children: [
            Column(
              children: [
                const BorderContainer(
                    title: '일반',
                    body: '일반적으로 선택할 수 있는 선택지예요.',
                    backgroundColor: AppColors.grey),
                PaddingColumn(
                  children: [
                    GestureDetector(
                      onTap: () => controller.toTimeSetPage(DeviceTimeSync()),
                      child: const BorderContainer(
                          title: '📱내 기기 시간', body: '이 기기의 시간을 사용할래요.'),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.SERVER_URL_INPUT),
                      child: const BorderContainer(
                          title: '🌐서버 시간',
                          body:
                              '수강신청/티켓팅 서버의 시간을 사용할래요.\n대부분 서비스에서 제공하는 방식이에요.'),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const BorderContainer(
                    title: '✨더 정확한 시간',
                    body: '서버로부터 밀리초(ms) 뿐만아니라 마이크로초(μs)까지의 더 세밀한 시간 정보를 받아와요.',
                    backgroundColor: AppColors.grey),
                if (kIsWeb)
                  const PaddingColumn(children: [
                    UseAppBanner(),
                  ]),
                if (!kIsWeb)
                  PaddingColumn(
                    children: [
                      GestureDetector(
                        onTap: () => controller
                            .toTimeSetPage(NTPTimeSync('ubuntu.pool.ntp.org')),
                        child: const BorderContainer(
                            title: '🟠우분투',
                            body: '많은 서버가 시간을 맞추기 위해 사용하는 서버예요'),
                      ),
                      GestureDetector(
                        onTap: () => controller
                            .toTimeSetPage(NTPTimeSync("pool.ntp.org")),
                        child: const BorderContainer(
                            title: '⚫️pool.ntp.org',
                            body: '전 세계적으로 분산된 시간 제공 서버'),
                      ),
                      GestureDetector(
                        onTap: () => controller
                            .toTimeSetPage(NTPTimeSync("time.google.com")),
                        child: const BorderContainer(
                            title: '🔵Google', body: '구글이 제공하는 시간'),
                      ),
                      GestureDetector(
                        onTap: () => controller
                            .toTimeSetPage(NTPTimeSync("time.windows.com")),
                        child: const BorderContainer(
                            title: '🟢Microsoft', body: '마이크로소프트가 제공하는 시간'),
                      ),
                      GestureDetector(
                        onTap: () => controller
                            .toTimeSetPage(NTPTimeSync("time.apple.com")),
                        child: const BorderContainer(
                            title: '🔴Apple', body: '애플이 제공하는 시간'),
                      ),
                      GestureDetector(
                        onTap: () => controller
                            .toTimeSetPage(NTPTimeSync("time.kriss.re.kr")),
                        child: const BorderContainer(
                            title: '🇰🇷한국표준과학연구원(KRISS)',
                            body: '한국표준과학연구원(KRISS)이 제공하는 시간'),
                      ),
                      GestureDetector(
                        onTap: () => controller
                            .toTimeSetPage(NTPTimeSync("time.kriss.re.kr")),
                        child: const BorderContainer(
                            title: '🇺🇸NIST(미국 국립표준기술연구소)',
                            body: 'NIST(미국 국립표준기술연구소)가 제공하는 매우 정확한 시간'),
                      ),
                    ],
                  ),
              ],
            )
          ],
        )
      ],
    );
  }
}
