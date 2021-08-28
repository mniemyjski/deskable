import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:flutter/material.dart';

class BookingField extends StatefulWidget {
  final int time;
  final String user;
  final bool isOff;

  const BookingField({
    Key? key,
    required this.time,
    required this.user,
    this.isOff = false,
  }) : super(key: key);

  @override
  _BookingFieldState createState() => _BookingFieldState();
}

class _BookingFieldState extends State<BookingField> {
  String _booking = '';

  booking(String name) {
    setState(() {
      _booking = name;
      print('test: $_booking');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 1, child: Text('${widget.time}:00')),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.isOff && widget.user == "" && _booking != '')
                      InkWell(
                        onTap: () {
                          booking("");
                        },
                        child: Text(
                          _booking,
                        ),
                      ),
                    if (!widget.isOff && widget.user == "" && _booking == '')
                      InkWell(
                        onTap: () {

                        },
                        child: Text(
                          Languages.click_to_book(),
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                      ),
                    if (widget.isOff && widget.user == "")
                      Text(
                        Languages.excluded_from_the_booking(),
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    if (widget.user != "") Text(widget.user),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
