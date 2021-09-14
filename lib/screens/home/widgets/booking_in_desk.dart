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
  final Furniture furniture;
  final Room room;

  const BookingsInDesk({Key? key, required this.furniture, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int openClose = room.close - room.open;

    final state = context.watch<BookingCubit>().state;

    if (state.status != EBookingStatus.succeed)
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
      )..init(furniture.id),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeader(openClose),
          Builder(builder: (context) {
            return Container(
              width: double.infinity,
              child: CustomButton(
                onPressed: () => _onTap(context),
                child: Text(Languages.save()),
              ),
            );
          }),
        ],
      ),
    );
  }

  _onTap(BuildContext context) {
    final state = context.read<CreatorBookingCubit>().state;

    bool available = context.read<BookingCubit>().alreadyBookedOtherUser(state.booking);

    if (!available) {
      customFlashBar(context, Languages.already_booked_other_user());
      Navigator.pop(context);
      return;
    }

    available = context.read<BookingCubit>().alreadyBookedInOtherDesk(state.booking);

    if (!available) {
      customFlashBar(context, Languages.already_booked_in_other_desk());
      Navigator.pop(context);
      return;
    }

    if (state.booking.hoursBook.isNotEmpty) {
      context.read<BookingCubit>().create(state.booking);
    } else {
      context.read<BookingCubit>().delete(state.booking);
    }
    Navigator.pop(context);
  }

  Column _buildHeader(int openClose) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('${furniture.name}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
            ],
          ),
        ),
        Row(
          children: [
            Text('${Languages.description()}: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('${furniture.description}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
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
              return BookingField(room: room, field: furniture, index: i);
            },
          ),
        ),
      ],
    );
  }
}
