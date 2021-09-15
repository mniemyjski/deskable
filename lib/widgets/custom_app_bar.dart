import 'package:flutter/material.dart';

AppBar customAppBar({String? title}) {
  return AppBar(
    title: Text(title ?? ''),
    actions: [
      IconButton(onPressed: () => null, icon: Icon(Icons.messenger_outline)),
      IconButton(onPressed: () => null, icon: Icon(Icons.notifications_none)),
    ],
  );
}
