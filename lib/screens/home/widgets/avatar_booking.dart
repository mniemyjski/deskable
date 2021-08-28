import 'package:flutter/material.dart';

class AvatarBooking extends StatelessWidget {
  const AvatarBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: CircleAvatar(
        radius: 10,
        child: Icon(
          Icons.account_circle,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
