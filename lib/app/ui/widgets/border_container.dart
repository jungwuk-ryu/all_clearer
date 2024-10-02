import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../themes/app_colors.dart';

class BorderContainer extends StatelessWidget {
  final String title;
  final String body;
  final double verticalMargin;
  final double fontRawSize;
  final Color? backgroundColor;
  final TextInputType? keyboard;
  final TextEditingController? textEditingController;
  final Function(String)? onTextEditingSubmit;
  final List<TextInputFormatter>? formatters;
  final String? textFieldHint;
  final RxBool? checkBox;
  final Widget? child;

  const BorderContainer({super.key,
    this.title = "",
    this.body = "",
    this.fontRawSize = 14,
    this.checkBox,
    this.verticalMargin = 6.0,
    this.formatters,
    this.keyboard,
    this.backgroundColor,
    this.textEditingController,
    this.textFieldHint,
    this.onTextEditingSubmit,
    this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: verticalMargin.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(width: 1.r, color: AppColors.grey)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _getTitleWidget(),
                      if (body.isNotEmpty) _getBodyTextWidget(),
                    ],
                  )),
              _getCheckBoxWidget(),
            ],
          ),
          if (textEditingController != null) SizedBox(height: 10.h),
          _getTextFieldWidget(),
          if (child != null) Column(
            children: [
              SizedBox(height: 5.h),
              child!
            ],
          )
        ],
      ),
    );
  }

  Widget _getCheckBoxWidget() {
    if (checkBox == null) return const SizedBox.shrink();

    return Obx(() {
      return Checkbox.adaptive(
          value: checkBox!.value,
          onChanged: (newValue) {
            if (newValue == null) return;

            checkBox!.value = newValue;
          });
    });
  }

  Widget _getTextFieldWidget() {
    if (textEditingController == null) return const SizedBox.shrink();

    return SizedBox(
      height: 50.h,
      child: TextField(
        controller: textEditingController,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: formatters,
        maxLines: 1,
        keyboardType: keyboard,
        onTapOutside: (event) => FocusScope.of(Get.context!).unfocus(),
        onSubmitted: onTextEditingSubmit,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            hintText: textFieldHint,
            filled: true,
            fillColor: AppColors.grey.withOpacity(0.5)),
      ),
    );
  }

  Widget _getTitleWidget() {
    return Text(title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.text,
            fontSize: (fontRawSize + 1).spMin));
  }

  Widget _getBodyTextWidget() {
    return Text(body,
        style: TextStyle(
            color: AppColors.textBlueGrey, fontSize: fontRawSize.spMin));
  }
}
