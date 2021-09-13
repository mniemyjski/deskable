import 'dart:math';

import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/widgets/printer_x.dart';
import 'package:flutter/material.dart';

class FieldInRoom extends StatelessWidget {
  final Furniture? furniture;
  final GestureTapCallback? onTap;
  final bool edit;

  const FieldInRoom({Key? key, required this.furniture, required this.onTap, this.edit = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (furniture == null)
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      );

    if (furniture!.isEmpty && !edit) return Container();

    if (furniture!.isEmpty && edit) return InkWell(splashColor: Colors.grey, onTap: onTap, child: Container());

    return InkWell(
        splashColor: Colors.grey,
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(1),
          child: Stack(
            children: [
              RotationTransition(
                turns: AlwaysStoppedAnimation(furniture!.rotation / 360),
                child: Image.asset(furniture!.path,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    colorBlendMode: BlendMode.modulate),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    furniture?.name ?? '',
                    style: TextStyle(color: Colors.grey),
                  )),
              if (false) ...[
                CustomPaint(
                  size: Size(50, 50),
                  painter: PainterX(),
                )
              ],
            ],
          ),
        ));
  }
}
