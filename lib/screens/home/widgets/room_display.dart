import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/widgets/booking_in_desk.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:deskable/widgets/field_in_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class RoomDisplay extends StatelessWidget {
  const RoomDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedRoomCubit, SelectedRoomState>(
      builder: (context, state) {
        if (state.status == ESelectedRoomStatus.unknown || state.status == ESelectedRoomStatus.loading)
          return Center(
            child: CircularProgressIndicator(),
          );

        if (state.status == ESelectedRoomStatus.empty) return Container();

        Room room = state.room!;

        return Container(
          width: room.x * 65,
          height: room.y * 65,
          child: GridView.count(
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            crossAxisCount: room.x,
            children: List.generate(room.x * room.y, (index) {
              Furniture? a = room.furniture.firstWhereOrNull((element) => element.position == index);
              return FieldInRoom(
                furniture: a,
                onTap: a != null ? () => customDialog(context, BookingsInDesk(furniture: a, room: room, ctx: context)) : null,
              );
            }),
          ),
        );
      },
    );
  }
}
