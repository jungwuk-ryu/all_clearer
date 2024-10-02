import 'package:flutter/cupertino.dart';

class AdaptiveWrap extends StatelessWidget {
  final double gap;
  final List<Widget> children;

  const AdaptiveWrap({super.key, required this.children, this.gap = 20});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (children.isEmpty) {
        return const SizedBox.shrink();
      } else if (children.length == 1) {
        return children.first;
      }

      double width = constraints.maxWidth;
      List<Widget> colum1 = [];
      List<Widget> colum2 = [];

      if (width < 500) {
        return Column(children: children);
      }

      for (int i = 0; i < children.length; i++) {
        if (i % 2 == 0) {
          colum1.add(children[i]);
        } else {
          colum2.add(children[i]);
        }
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: colum1
          )),
          SizedBox(width: gap),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: colum2,
          ))
        ],
      );
    });
  }
}
