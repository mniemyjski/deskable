import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSelectorData extends StatelessWidget {
  final VoidCallback? onPressedBack;
  final VoidCallback? onPressedForward;
  final VoidCallback? onPressed;
  final String? name;

  const CustomSelectorData({Key? key, this.onPressedBack, this.onPressedForward, required this.onPressed, required this.name}) : super(key: key);

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
              child: Text(name!),
            ))),
        SizedBox(width: 8),
        if (onPressedForward != null)
          InkWell(
            child: FaIcon(FontAwesomeIcons.chevronRight, color: Colors.grey),
            onTap: onPressedForward,
          ),
      ],
    );
  }
}
