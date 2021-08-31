import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/widgets/schedule.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:deskable/widgets/custom_selector_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookingInRoom extends StatelessWidget {
  const BookingInRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: 520,
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
              BlocBuilder<SelectedCompanyCubit, SelectedCompanyState>(
                builder: (context, state) {
                  return CustomSelectorData(
                    onPressed: () => customDialog(
                      context,
                      BlocBuilder<CompanyCubit, CompanyState>(
                        builder: (context, state) {
                          return ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: state.companies!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(state.companies![index].name);
                              });
                        },
                      ),
                    ),
                    name: state.company?.name ?? '',
                  );
                },
              ),
              BlocBuilder<SelectedRoomCubit, SelectedRoomState>(
                builder: (context, state) {
                  return CustomSelectorData(
                    onPressed: () => customDialog(
                      context,
                      BlocBuilder<RoomCubit, RoomState>(
                        builder: (context, state) {
                          return ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: state.rooms!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(state.rooms![index].name);
                              });
                        },
                      ),
                    ),
                    name: state.room?.name ?? '',
                  );
                },
              ),
              CustomSelectorData(
                onPressedBack: () => context.read<SelectedDateCubit>().decrease(),
                onPressedForward: () => context.read<SelectedDateCubit>().increase(),
                onPressed: () {
                  showDatePicker(
                          context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(DateTime.now().year + 5))
                      .then((date) {
                    if (date != null) {
                      context.read<SelectedDateCubit>().change(date);
                    }
                  });
                },
                name: DateFormat('dd-MM-yyyy').format(context.watch<SelectedDateCubit>().state.dateTime),
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
