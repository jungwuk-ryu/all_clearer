import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaddingColumn extends StatelessWidget {
  final List<Widget> children;

  const PaddingColumn({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 15.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ));
  }
}
