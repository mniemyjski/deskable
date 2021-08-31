import 'package:deskable/cubit/account/account_cubit.dart';
import 'package:deskable/cubit/booking/booking_cubit.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/cubit/creator_booking_cubit.dart';
import 'package:deskable/screens/home/widgets/booking_field.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:deskable/utilities/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class BookingsInDesk extends StatelessWidget {
  final Field field;
  final Room room;

  const BookingsInDesk({Key? key, required this.field, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int openClose = room.close - room.open;

    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state.status != EStatus.succeed)
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );

        return BlocProvider(
          create: (context) => CreatorBookingCubit(
            selectedDateCubit: context.read<SelectedDateCubit>(),
            bookingCubit: context.read<BookingCubit>(),
            selectedRoomCubit: context.read<SelectedRoomCubit>(),
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
                        return BookingField(room: room, field: field, index: i);
                      },
                    ),
                  ),
                ],
              ),
              BlocBuilder<CreatorBookingCubit, CreatorBookingState>(
                builder: (context, state) {
                  return TextButton(
                      onPressed: () {
                        context.read<BookingCubit>().create(state.booking);
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
