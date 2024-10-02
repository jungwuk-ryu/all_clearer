import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RxBoolVisibility extends StatelessWidget {
  final RxBool rx;
  final Widget child;

  const RxBoolVisibility({super.key, required this.rx, required this.child});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        if (rx.isFalse) return const SizedBox.shrink();
        return child;
      },
    );
  }

}