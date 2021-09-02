import 'package:deskable/cubit/cubit.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

customFlashBar(BuildContext context, String text) {
  return showFlash(
      context: context,
      duration: Duration(seconds: 2),
      builder: (context, controller) {
        return BlocBuilder<DarkModeCubit, bool>(
          builder: (context, state) {
            return Padding(
                padding: const EdgeInsets.all(8),
                child: Flash(
                  controller: controller,
                  behavior: FlashBehavior.fixed,
                  position: FlashPosition.bottom,
                  backgroundColor: state ? Colors.black54 : Colors.white,
                  boxShadows: kElevationToShadow[4],
                  child: FlashBar(
                    content: Center(child: Text(text, style: TextStyle(color: state ? Colors.white : Colors.black54))),
                  ),
                ));
          },
        );
      });
}
