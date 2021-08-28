import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/widgets/schedule.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:deskable/widgets/custom_selector_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingInRoom extends StatelessWidget {
  final Room room;

  const BookingInRoom({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSelectorData(
                onPressedBack: () => null,
                onPressedForward: () => null,
                onPressed: () => customDialog(context, Text('LIST_COMPANY')),
                name: 'Canal+',
              ),
              CustomSelectorData(
                onPressedBack: () => null,
                onPressedForward: () => null,
                onPressed: () => customDialog(context, Text('LIST_ROOMS')),
                name: room.name,
              ),
              CustomSelectorData(
                onPressedBack: () => null,
                onPressedForward: () => null,
                onPressed: () {
                  showDatePicker(
                          context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(DateTime.now().year + 5))
                      .then((date) {
                    if (date != null) {}
                  });
                },
                name: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              ),
            ],
          ),
          SizedBox(height: 25),
          Schedule(),
        ],
      ),
    );
  }
}
