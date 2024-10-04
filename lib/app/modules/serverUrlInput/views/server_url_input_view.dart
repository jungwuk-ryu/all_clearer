import 'package:allclearer/app/ui/themes/app_colors.dart';
import 'package:allclearer/app/ui/widgets/border_container.dart';
import 'package:allclearer/app/ui/widgets/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/server_url_input_controller.dart';

class ServerUrlInputView extends GetView<ServerUrlInputController> {
  const ServerUrlInputView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('페이지 URL 입력'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: _body(),
      )),
    );
  }

  Widget _body() {
    return Column(
      children: [
        BorderContainer(
          title: '웹 페이지 주소',
          body: '서버 시간을 알고 싶은 웹 페이지 주소를 입력해주세요',
          textEditingController: controller.getUriInputController(),
          textFieldHint: '예시: https://naver.com',
          onTextEditingSubmit: (_) => controller.onButtonClick(),
        ),
        SizedBox(height: 10.h),
        Obx(() {
          if (controller.getRecentHostList().isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('최근 사용한 주소', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.spMin)),
                Text('꾹 눌러 삭제할 수 있어요', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.spMin, color: AppColors.textBlueGrey))
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
        Expanded(child: Obx(() {
          List<String> list = controller.getRecentHostList();

          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
            String host = list[index];
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => controller.setHost(host),
              onLongPress: () {
                controller.removeHostFromRecentHostList(host);
                HapticFeedback.lightImpact();
              },
              child: Obx(() => BorderContainer(
                title: host,
                body: controller.getWebTitle(host).value,
              )),
            );
          });
        },)),
        NormalButton(callback: controller.onButtonClick, text: '다음')
      ],
    );
  }
}
