import 'package:deskable/cubit/cubit.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

customFlashBar(BuildContext context, String text) {
  return showFlash(
    context: context,
    duration: Duration(seconds: 2),
    builder: (context, controller) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Flash(
          controller: controller,
          behavior: FlashBehavior.floating,
          position: FlashPosition.bottom,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: BlocBuilder<DarkModeCubit, bool>(
              builder: (context, state) {
                return Text(text, style: TextStyle(color: state ? Colors.black : Colors.white));
              },
            ),
          ),
        ),
      );
    },
  );
}
