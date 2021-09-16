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
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: InkWell(
              child: FaIcon(FontAwesomeIcons.chevronLeft),
              onTap: onPressedBack,
            ),
          ),
        SizedBox(width: 4),
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(height: 30, child: Center(child: widget)),
            ),
          ),
        ),
        SizedBox(width: 4),
        if (onPressedNext != null)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: InkWell(
              child: FaIcon(FontAwesomeIcons.chevronRight),
              onTap: onPressedNext,
            ),
          ),
      ],
    );
  }
}
