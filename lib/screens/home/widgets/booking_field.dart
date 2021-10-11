import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/cubit/creator_booking_cubit.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingField extends StatefulWidget {
  final int index;
  final Room room;
  final Furniture field;

  const BookingField({
    Key? key,
    required this.index,
    required this.room,
    required this.field,
  }) : super(key: key);

  @override
  _BookingFieldState createState() => _BookingFieldState();
}

class _BookingFieldState extends State<BookingField> {
  String name = '';
  Booking? booking;

  @override
  void initState() {
    booking = context.read<BookingCubit>().getBooking(
        deskId: widget.field.id, hour: widget.room.open + widget.index);
    name = booking?.account!.name ?? Strings.click_to_book();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1, child: Text('${widget.room.open + widget.index}:00')),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (booking != null &&
                    booking?.userId !=
                        context.read<AccountCubit>().state.account!.uid)
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(4.0),
                      child: Text(name)),
                if (booking == null ||
                    booking?.userId ==
                        context.read<AccountCubit>().state.account!.uid)
                  InkWell(
                    onTap: () => _onTap(context),
                    child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(4.0),
                        child: Text(
                          name,
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey),
                        )),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onTap(BuildContext context) {
    setState(() {
      if (name == Strings.click_to_book()) {
        name = context.read<AccountCubit>().state.account!.name;
        context
            .read<CreatorBookingCubit>()
            .add(widget.room.open + widget.index);
      } else if (name != Strings.click_to_book()) {
        name = Strings.click_to_book();
        context
            .read<CreatorBookingCubit>()
            .remove(widget.room.open + widget.index);
      }
    });
  }
}
