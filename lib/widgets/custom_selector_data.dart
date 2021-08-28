import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSelectorData extends StatelessWidget {
  final VoidCallback? onPressedBack;
  final VoidCallback? onPressedForward;
  final VoidCallback? onPressed;
  final String? name;

  const CustomSelectorData({Key? key, required this.onPressedBack, required this.onPressedForward, required this.onPressed, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.grey),
          onTap: onPressedBack,
        ),
        InkWell(
            onTap: onPressed,
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(name!),
            ))),
        InkWell(
          child: FaIcon(FontAwesomeIcons.chevronRight, color: Colors.grey),
          onTap: onPressedForward,
        ),
      ],
    );
  }
}
