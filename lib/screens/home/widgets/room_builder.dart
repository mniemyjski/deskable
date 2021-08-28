import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/widgets/field_in_room.dart';
import 'package:flutter/material.dart';

class RoomBuilder extends StatelessWidget {
  final Room room;

  const RoomBuilder({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: room.x * 65,
      height: room.y * 65,
      child: GridView.count(
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        crossAxisCount: room.x,
        children: List.generate(room.x * room.y, (index) {
          Field a = room.fields.firstWhere((element) => element.id == index, orElse: () => Field(id: index));
          return FieldInRoom(field: a, room: room);
        }),
      ),
    );
  }
}
