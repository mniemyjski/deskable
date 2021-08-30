import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/screens/home/widgets/avatar_booking.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            // Expanded(flex: 5, child: Text('${Languages.free()}:', style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(flex: 5, child: Text('${Languages.bookings()}:', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        Divider(),
        Container(
          height: 400,
          child: BlocBuilder<SelectedRoomCubit, SelectedRoomState>(
            builder: (context, stateA) {
              if (stateA.status != EStatus.succeed)
                return Center(
                  child: CircularProgressIndicator(),
                );

              return BlocBuilder<BookingCubit, BookingState>(
                builder: (context, stateB) {
                  if (stateB.status != EStatus.succeed)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: stateA.room!.close - stateA.room!.open,
                      itemBuilder: (BuildContext context, int index) {
                        List<String> photosUrl =
                            context.read<BookingCubit>().getListUserRoomBookingInTime(time: stateA.room!.open + index, name: true);
                        List<String> usersName =
                            context.read<BookingCubit>().getListUserRoomBookingInTime(time: stateA.room!.open + index, name: false);

                        return buildBookingInTime(
                          context: context,
                          time: stateA.room!.open + index,
                          count: usersName.length,
                          usersName: usersName,
                          photosUrl: photosUrl,
                        );
                      });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Row buildBookingInTime(
      {required BuildContext context, required int time, required count, required List<String> photosUrl, required List<String> usersName}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 2, child: Text('$time:00')),
        Expanded(flex: 2, child: Text(count.toString())),
        // Expanded(
        //   flex: 5,
        //   child: InkWell(
        //     onTap: () => null,
        //     child: Row(
        //       children: [
        //         Card(
        //           child: Padding(
        //             padding: const EdgeInsets.all(4.0),
        //             child: Text('1'),
        //           ),
        //         ),
        //         Card(
        //           child: Padding(
        //             padding: const EdgeInsets.all(4.0),
        //             child: Text('2'),
        //           ),
        //         ),
        //         Card(
        //           child: Padding(
        //             padding: const EdgeInsets.all(4.0),
        //             child: Text('3'),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        Expanded(
          flex: 5,
          child: TextButton(
            onPressed: () => customDialog(
                context,
                ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: usersName.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            AvatarBooking(url: photosUrl[index]),
                            SizedBox(width: 8),
                            Text(usersName[index]),
                          ],
                        ),
                      );
                    })),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: List.generate(
                    photosUrl.length > 5 ? 5 : photosUrl.length,
                    (index) => AvatarBooking(
                          url: photosUrl[index],
                        )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
