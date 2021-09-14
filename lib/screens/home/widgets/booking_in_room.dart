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
              _buildCompanySelector(),
              _buildRoomSelector(),
              _buildDateSelector(context),
            ],
          ),
          SizedBox(height: 8),
          Schedule(),
        ],
      ),
    );
  }

  CustomSelectorData _buildDateSelector(BuildContext context) {
    return CustomSelectorData(
      onPressedBack: () => context.read<SelectedDateCubit>().decrease(),
      onPressedForward: () => context.read<SelectedDateCubit>().increase(),
      onPressed: () {
        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(DateTime.now().year + 5))
            .then((date) {
          if (date != null) {
            context.read<SelectedDateCubit>().change(date);
          }
        });
      },
      widget: BlocBuilder<SelectedDateCubit, SelectedDateState>(
        builder: (context, state) {
          return Column(
            children: [
              Text(DateFormat('dd-MM-yyyy').format(state.dateTime)),
              Text(state.name),
            ],
          );
        },
      ),
    );
  }

  Builder _buildRoomSelector() {
    return Builder(
      builder: (context) {
        final stateA = context.watch<SelectedRoomCubit>().state;
        final stateB = context.watch<RoomCubit>().state;

        if (stateB.status == ERoomStatus.empty) return Container();

        return CustomSelectorData(
          onPressed: () => customDialog(
            context,
            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: stateB.rooms!.length,
                itemBuilder: (BuildContext _, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<SelectedRoomCubit>().change(stateB.rooms![index]);
                        Navigator.pop(context);
                      },
                      child: Text(stateB.rooms![index].name),
                    ),
                  );
                }),
          ),
          widget: Text(stateA.room?.name ?? ''),
        );
      },
    );
  }

  Builder _buildCompanySelector() {
    return Builder(
      builder: (context) {
        final stateA = context.watch<CompanyCubit>().state;
        final stateB = context.watch<SelectedCompanyCubit>().state;

        return CustomSelectorData(
          onPressed: () => customDialog(
            context,
            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: stateA.companies!.length,
                itemBuilder: (BuildContext _, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<SelectedCompanyCubit>().change(stateA.companies![index]);
                        Navigator.pop(context);
                      },
                      child: Text(stateA.companies![index].name),
                    ),
                  );
                }),
          ),
          widget: Text(stateB.company?.name ?? ''),
        );
      },
    );
  }
}
