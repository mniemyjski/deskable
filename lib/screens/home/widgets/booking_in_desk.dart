import 'package:deskable/cubit/account/account_cubit.dart';
import 'package:deskable/cubit/booking/booking_cubit.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/cubit/creator_booking_cubit.dart';
import 'package:deskable/screens/home/widgets/booking_field.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:deskable/utilities/languages.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class BookingsInDesk extends StatelessWidget {
  final Field field;
  final Room room;
  final BuildContext ctx;

  const BookingsInDesk({Key? key, required this.field, required this.room, required this.ctx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int openClose = room.close - room.open;

    return Builder(
      builder: (context) {
        final state = ctx.watch<BookingCubit>().state;

        if (state.status != EStatus.succeed)
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );

        return BlocProvider(
          create: (context) => CreatorBookingCubit(
            selectedDateCubit: ctx.read<SelectedDateCubit>(),
            bookingCubit: ctx.read<BookingCubit>(),
            selectedRoomCubit: ctx.read<SelectedRoomCubit>(),
          )..init(field.id),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text('Id: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
                        Text('${field.id}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('${field.name}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text('${Languages.description()}: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('${field.description}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text('${Languages.time()}', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 3, child: Text('${Languages.bookings()}', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                  Divider(),
                  Container(
                    height: 330,
                    child: ListView.builder(
                      itemCount: openClose,
                      itemBuilder: (context, i) {
                        return BookingField(room: room, field: field, index: i, ctx: ctx);
                      },
                    ),
                  ),
                ],
              ),
              BlocBuilder<CreatorBookingCubit, CreatorBookingState>(
                builder: (context, state) {
                  return TextButton(
                      onPressed: () {
                        bool available = ctx.read<BookingCubit>().available(state.booking);

                        if (!available) {
                          customFlashBar(context, Languages.already_booked());
                          Navigator.pop(context);
                          return;
                        }

                        if (state.booking.hoursBook.isNotEmpty) {
                          ctx.read<BookingCubit>().create(state.booking);
                        } else {
                          ctx.read<BookingCubit>().delete(state.booking);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(Languages.save()));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
