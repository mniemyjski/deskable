import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

customDialog(BuildContext context, Widget body) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400.0,
                  minHeight: 100,
                  maxHeight: 500.0,
                ),
                child: body));
      });
}
