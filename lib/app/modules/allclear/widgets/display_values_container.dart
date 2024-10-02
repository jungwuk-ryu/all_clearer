import 'package:allclearer/app/data/setting_display_value_data.dart';
import 'package:allclearer/app/ui/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DisplayValuesContainer extends StatelessWidget {
  final SettingDisplayValueData data;

  const DisplayValuesContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _valueContainer('목표', data.goal),
            SizedBox(width: 0.5.w),
            _valueContainer('일', data.day),
            SizedBox(width: 0.5.w),
            _valueContainer('시', data.hour),
            SizedBox(width: 0.5.w),
            _valueContainer('분', data.minute),
            SizedBox(width: 0.5.w),
            _valueContainer('초', data.second),
            SizedBox(width: 0.5.w),
            _valueContainer('ms', data.millisecond),
          ],
        ));
  }

  Widget _valueContainer(String name, RxBool data) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        data.value = !data.value;
      },
      child: Obx(() {
        Color color = data.isTrue ? AppColors.primary : AppColors.grey;

        return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: 60.h,
            //margin: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
                color: color,
                //borderRadius: BorderRadius.circular(12.r),
                ),
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15.spMin,
                    color: color.computeLuminance() > 0.5
                        ? Colors.black87
                        : Colors.white),
              ),
            ));
      }),
    ));
  }
}
