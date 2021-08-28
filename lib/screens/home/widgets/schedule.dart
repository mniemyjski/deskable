import 'package:deskable/screens/home/widgets/avatar_booking.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

class Schedule extends StatelessWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 2, child: Text('${Languages.time()}:', style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(flex: 2, child: Text('${Languages.count()}:', style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(flex: 5, child: Text('${Languages.free()}:', style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(flex: 5, child: Text('${Languages.bookings()}:', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        Divider(),
        Container(
          height: 400,
          child: ListView(
            children: [
              buildBookingInTime(context: context, time: 6, count: 5, list: []),
              buildBookingInTime(context: context, time: 7, count: 5, list: []),
              buildBookingInTime(context: context, time: 8, count: 5, list: []),
              buildBookingInTime(context: context, time: 9, count: 5, list: []),
              buildBookingInTime(context: context, time: 10, count: 5, list: []),
              buildBookingInTime(context: context, time: 11, count: 5, list: []),
              buildBookingInTime(context: context, time: 12, count: 5, list: []),
              buildBookingInTime(context: context, time: 13, count: 5, list: []),
              buildBookingInTime(context: context, time: 14, count: 5, list: []),
              buildBookingInTime(context: context, time: 15, count: 5, list: []),
              buildBookingInTime(context: context, time: 16, count: 5, list: []),
              buildBookingInTime(context: context, time: 17, count: 5, list: []),
              buildBookingInTime(context: context, time: 18, count: 5, list: []),
              buildBookingInTime(context: context, time: 19, count: 5, list: []),
              buildBookingInTime(context: context, time: 20, count: 5, list: []),
              buildBookingInTime(context: context, time: 21, count: 5, list: []),
              buildBookingInTime(context: context, time: 22, count: 5, list: []),
              buildBookingInTime(context: context, time: 23, count: 5, list: []),
              buildBookingInTime(context: context, time: 24, count: 5, list: []),
            ],
          ),
        ),
      ],
    );
  }

  Row buildBookingInTime({required BuildContext context, required int time, required count, required List list}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 2, child: Text('$time:00')),
        Expanded(flex: 2, child: Text(count.toString())),
        Expanded(
          flex: 5,
          child: InkWell(
            onTap: () => null,
            child: Row(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('1'),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('2'),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('3'),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
            onPressed: () => customDialog(context, Text("List_USER")),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  AvatarBooking(),
                  AvatarBooking(),
                  AvatarBooking(),
                  AvatarBooking(),
                  AvatarBooking(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
