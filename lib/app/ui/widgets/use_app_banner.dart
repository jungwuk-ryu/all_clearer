import 'package:allclearer/app/ui/widgets/border_container.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'app_button.dart';

class UseAppBanner extends StatelessWidget {
  const UseAppBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      title: '모바일 앱에서 더욱 정확한 시간을 확인해요!',
      body:
          '앱을 사용하면 그 누구보다 정확한 서버 시간으로 성공률을 높일 수 있어요.\n심지어 진동📳과 같은 효과들도 제공돼요!',
      child: AppButton(callback: _openTab, text: '지금 다운로드 하기!'),
    );
  }

  Future<void> _openTab() async {
    await launchUrlString(
      "https://apps.apple.com/kr/app/id6711347479",
      mode: LaunchMode.externalApplication,
    );
  }
}
