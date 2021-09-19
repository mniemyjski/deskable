import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/utilities/languages.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

customFlashBar(BuildContext context, String text) {
  return showFlash(
      context: context,
      duration: Duration(seconds: 3),
      builder: (context, controller) {
        return BlocBuilder<DarkModeCubit, bool>(
          builder: (context, state) {
            return Padding(
                padding: const EdgeInsets.all(8),
                child: Flash(
                  margin: EdgeInsets.only(top: 55),
                  controller: controller,
                  behavior: FlashBehavior.fixed,
                  position: FlashPosition.top,
                  backgroundColor: Colors.black54,
                  boxShadows: kElevationToShadow[2],
                  child: FlashBar(
                    primaryAction: TextButton(
                      onPressed: () => controller.dismiss(),
                      child: Text(Languages.dismiss(), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    content: Center(child: Text(text, style: TextStyle(color: Colors.white))),
                  ),
                ));
          },
        );
      });
}
