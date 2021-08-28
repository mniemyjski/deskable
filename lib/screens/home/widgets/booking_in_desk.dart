import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/widgets/booking_field.dart';
import 'package:deskable/utilities/languages.dart';
import 'package:flutter/material.dart';

class BookingsInDesk extends StatelessWidget {
  final Field field;
  final Room room;

  const BookingsInDesk({Key? key, required this.field, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text('Id: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
              height: 350,
              child: ListView.builder(
                itemCount: room.close - room.open,
                itemBuilder: (context, i) {
                  return BookingField(time: room.open + i, user: "");
                },
              ),
            ),
          ],
        ),
        TextButton(onPressed: () => null, child: Text(Languages.save())),
      ],
    );
  }
}
