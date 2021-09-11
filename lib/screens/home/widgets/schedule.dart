import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
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
              if (stateA.status == ESelectedRoomStatus.unknown || stateA.status == ESelectedRoomStatus.loading)
                return Center(
                  child: CircularProgressIndicator(),
                );

              if (stateA.status == ESelectedRoomStatus.empty)
                return Center(
                  child: Text(Languages.need_create_first_room()),
                );

              return BlocBuilder<BookingCubit, BookingState>(
                builder: (context, stateB) {
                  if (stateB.status != EBookingStatus.succeed)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  return ListView.builder(
                      itemCount: stateA.room!.close - stateA.room!.open,
                      itemBuilder: (BuildContext context, int index) {
                        List<Account> accounts = context.read<BookingCubit>().getListUserRoomBookingInTime(stateA.room!.open + index);

                        return buildBookingInTime(
                          context: context,
                          time: stateA.room!.open + index,
                          accounts: accounts,
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

  Row buildBookingInTime({required BuildContext context, required int time, required List<Account> accounts}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 2, child: Text('$time:00')),
        Expanded(flex: 2, child: Text(accounts.length.toString())),
        Expanded(
          flex: 5,
          child: accounts.isNotEmpty
              ? TextButton(
                  onPressed: () => customDialog(
                      context,
                      ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: accounts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  AvatarBooking(url: accounts[index].photoUrl),
                                  SizedBox(width: 8),
                                  Text(accounts[index].name),
                                ],
                              ),
                            );
                          })),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: List.generate(
                          accounts.length > 5 ? 5 : accounts.length,
                          (index) => AvatarBooking(
                                url: accounts[index].photoUrl,
                              )),
                    ),
                  ),
                )
              : Padding(padding: EdgeInsets.all(13)),
        ),
      ],
    );
  }
}
