import 'package:auto_size_text/auto_size_text.dart';
import 'package:deskable/cubit/booking/incoming_booking_cubit.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/booking_repository.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomingBooking extends StatelessWidget {
  const IncomingBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncomingBookingCubit(
        bookingRepository: context.read<BookingRepository>(),
        selectedOrganizationCubit: context.read<SelectedOrganizationCubit>(),
        accountCubit: context.read<AccountCubit>(),
      ),
      child: BlocBuilder<IncomingBookingCubit, IncomingBookingState>(
        builder: (context, state) {
          if (state.status != EIncomingStatus.succeed) return Container();

          return Card(
            child: Container(
              padding: EdgeInsets.all(8),
              width: 520,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _textHeader(Languages.date(), 1),
                      _textHeader(Languages.room(), 2),
                      _textHeader(Languages.position(), 1),
                      _textHeader(Languages.time(), 2),
                    ],
                  ),
                  SizedBox(height: 4),
                  Divider(),
                  Container(
                    height: (state.bookings.length * 27) + 20,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: state.bookings.length,
                      itemBuilder: (BuildContext _, int index) {
                        Room? room = context.read<RoomCubit>().getRoom(state.bookings[index].roomId!);
                        Furniture? furniture = context.read<RoomCubit>().getFurniture(state.bookings[index].deskId!);

                        return Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                DateFormat('dd-MM-yyyy').format(state.bookings[index].dateBook!),
                                maxLines: 1,
                                minFontSize: 6,
                                maxFontSize: 12,
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: AutoSizeText(
                                  room?.name ?? '',
                                  maxLines: 1,
                                  minFontSize: 6,
                                  maxFontSize: 12,
                                )),
                            Expanded(
                                flex: 1,
                                child: AutoSizeText(
                                  furniture?.name ?? '',
                                  maxLines: 1,
                                  minFontSize: 6,
                                  maxFontSize: 12,
                                )),
                            Expanded(
                              flex: 2,
                              child: AutoSizeText(
                                state.bookings[index].hoursBook.toString().replaceAll('[', '').replaceAll(']', ''),
                                maxLines: 1,
                                minFontSize: 6,
                                maxFontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Expanded _textHeader(String name, int flex) => Expanded(flex: flex, child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)));
}
