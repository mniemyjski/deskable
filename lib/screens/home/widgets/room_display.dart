import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/widgets/field_in_room.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class RoomDisplay extends StatelessWidget {
  const RoomDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedRoomCubit, SelectedRoomState>(
      builder: (context, state) {
        if (state.status != EStatus.succeed)
          return Center(
            child: CircularProgressIndicator(),
          );

        Room room = state.room!;

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
      },
    );
  }
}
