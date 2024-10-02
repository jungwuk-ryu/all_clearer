import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../themes/app_colors.dart';

class NormalButton extends StatelessWidget {
  final Function() callback;
  final String text;
  final RxBool _isLoading = RxBool(false);

  NormalButton({super.key, required this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: double.infinity,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.primary,
        ),
        child: Center(
          child: Obx(
            () {
              if (_isLoading.isTrue) {
                return const CircularProgressIndicator.adaptive();
              } else {
                return Text(
                  text,
                  style: TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.spMin),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> action() async {
    if (_isLoading.isTrue) return;
    _isLoading.value = true;

    try {
      dynamic callbackRet = callback.call();
      await callbackRet;
    } catch (e, st) {
      log('예외 발생', error: e, stackTrace: st);
    } finally {
      _isLoading.value = false;
    }
  }

}