import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/widgets/avatar_booking.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
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
        Builder(
          builder: (context) {
            final stateA = context.watch<SelectedRoomCubit>().state;
            final stateB = context.watch<BookingCubit>().state;

            if (stateA.status == ESelectedRoomStatus.empty)
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(Languages.need_create_first_room()),
              ));

            if (stateB.status == EBookingStatus.succeed)
              return Container(
                height: (stateA.room!.close - stateA.room!.open) * 28,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: stateA.room!.close - stateA.room!.open,
                    itemBuilder: (BuildContext context, int index) {
                      List<Account> accounts = context.read<BookingCubit>().getListUserRoomBookingInTime(stateA.room!.open + index);

                      return buildBookingInTime(
                        context: context,
                        time: stateA.room!.open + index,
                        accounts: accounts,
                      );
                    }),
              );

            return CustomLoadingWidget(color: Theme.of(context).primaryColor);
          },
        ),
      ],
    );
  }

  Container buildBookingInTime({required BuildContext context, required int time, required List<Account> accounts}) {
    return Container(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text('$time:00')),
          Expanded(flex: 2, child: Text(accounts.length.toString())),
          Expanded(
            flex: 5,
            child: accounts.isNotEmpty
                ? InkWell(
                    onTap: () => customDialog(
                        context,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(flex: 2, child: Text(Languages.name(), style: TextStyle(fontWeight: FontWeight.bold))),
                                  Expanded(flex: 1, child: Text(Languages.position(), style: TextStyle(fontWeight: FontWeight.bold))),
                                ],
                              ),
                              Divider(),
                              Container(
                                height: 300,
                                child: ListView.builder(
                                    itemCount: accounts.length,
                                    itemBuilder: (BuildContext _, int index) {
                                      String? deskId = context.read<BookingCubit>().getDeskIdInTime(time: time, account: accounts[index]);

                                      Furniture? furniture = context.read<SelectedRoomCubit>().getFurniture(deskId ?? "");

                                      return Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                AvatarBooking(url: accounts[index].photoUrl),
                                                SizedBox(width: 8),
                                                Text(accounts[index].name),
                                              ],
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(furniture?.name ?? '?')),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        )),
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
                : Container(),
          ),
        ],
      ),
    );
  }
}
