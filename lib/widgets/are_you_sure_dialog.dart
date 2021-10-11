import 'package:deskable/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> areYouSureDialog(BuildContext context) async {
  bool? _areYouSureDialog = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Strings.are_you_sure_you_want_to_do_this()),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(Strings.no())),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(Strings.yes())),
          ],
        );
      });
  return _areYouSureDialog ?? false;
}
