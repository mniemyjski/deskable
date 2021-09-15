import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSelectorData extends StatelessWidget {
  final VoidCallback? onPressedBack;
  final VoidCallback? onPressedNext;
  final VoidCallback? onPressed;
  final Widget widget;

  const CustomSelectorData({Key? key, this.onPressedBack, this.onPressedNext, required this.onPressed, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onPressedBack != null)
          InkWell(
            child: FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.grey),
            onTap: onPressedBack,
          ),
        SizedBox(width: 8),
        InkWell(
            onTap: onPressed,
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget,
            ))),
        SizedBox(width: 8),
        if (onPressedNext != null)
          InkWell(
            child: FaIcon(FontAwesomeIcons.chevronRight, color: Colors.grey),
            onTap: onPressedNext,
          ),
      ],
    );
  }
}
