import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/cubit/creator_booking_cubit.dart';
import 'package:deskable/screens/home/widgets/booking_in_desk.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:deskable/widgets/custom_loading_widget.dart';
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
          return CustomLoadingWidget(color: Theme.of(context).primaryColor);

        if (state.status == ESelectedRoomStatus.empty) return Container();

        Room room = state.room!;

        return Container(
          padding: const EdgeInsets.only(top: 4),
          width: room.x * 65,
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            crossAxisCount: room.x,
            children: List.generate(room.x * room.y, (index) {
              Furniture? furniture = room.furniture.firstWhereOrNull((element) => element.position == index);
              return FieldInRoom(
                furniture: furniture,
                onTap: furniture != null
                    ? () => customDialog(
                          context,
                          MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: BlocProvider.of<BookingCubit>(context),
                              ),
                              BlocProvider.value(
                                value: BlocProvider.of<SelectedDateCubit>(context),
                              ),
                              BlocProvider.value(
                                value: BlocProvider.of<SelectedRoomCubit>(context),
                              ),
                            ],
                            child: BookingsInDesk(furniture: furniture, room: room),
                          ),
                        )
                    : null,
              );
            }),
          ),
        );
      },
    );
  }
}
