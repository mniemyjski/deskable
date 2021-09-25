import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

customFlashBar(String text) {
  return BotToast.showCustomNotification(
    align: Alignment.center,
    duration: Duration(seconds: 3),
    toastBuilder: (void Function() cancelFunc) {
      return Card(
        color: Colors.black26,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    },
  );
}
