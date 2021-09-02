import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/widgets/booking_in_desk.dart';
import 'package:deskable/screens/home/widgets/printer_x.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class FieldInRoom extends StatelessWidget {
  final Field field;
  final Room room;

  const FieldInRoom({Key? key, required this.field, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (field.isEmpty) return Container();

    if (field.path == '')
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      );

    return InkWell(
        splashColor: Colors.grey,
        onTap: () {
          customDialog(context, BookingsInDesk(field: field, room: room, ctx: context));
        },
        child: Container(
          margin: EdgeInsets.all(1),
          child: Stack(
            children: [
              RotationTransition(
                turns: AlwaysStoppedAnimation(field.rotation / 360),
                child: Image.asset(
                  field.path,
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    field.name,
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
