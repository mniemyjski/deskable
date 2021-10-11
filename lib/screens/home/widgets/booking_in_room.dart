import 'package:auto_size_text/auto_size_text.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/screens/home/widgets/schedule.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_button.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:deskable/widgets/custom_selector_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookingInRoom extends StatelessWidget {
  const BookingInRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8),
        width: 520,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 3, child: _buildCompanySelector()),
                  SizedBox(width: 8),
                  Expanded(flex: 3, child: _buildRoomSelector()),
                  SizedBox(width: 8),
                  Expanded(flex: 5, child: _buildDateSelector(context)),
                ],
              ),
            ),
            Schedule(),
          ],
        ),
      ),
    );
  }

  CustomSelectorData _buildDateSelector(BuildContext context) {
    return CustomSelectorData(
      onPressedBack: () => context.read<SelectedDateCubit>().decrease(),
      onPressedNext: () => context.read<SelectedDateCubit>().increase(),
      onPressed: () {
        showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(DateTime.now().year + 5))
            .then((date) {
          if (date != null) {
            context.read<SelectedDateCubit>().change(date);
          }
        });
      },
      widget: BlocBuilder<SelectedDateCubit, SelectedDateState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                DateFormat('dd-MM-yyyy').format(state.dateTime),
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                minFontSize: 6,
                maxFontSize: 12,
              ),
              AutoSizeText(
                state.name,
                style: TextStyle(fontStyle: FontStyle.italic),
                maxLines: 1,
                minFontSize: 6,
                maxFontSize: 12,
              ),
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

        if (stateB.status == ERoomStatus.empty ||
            stateA.status != ESelectedRoomStatus.succeed) return Container();

        return CustomSelectorData(
          onPressed: () => customDialog(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 16, bottom: 16),
                    child: Text(
                      '${Strings.rooms()}:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 440,
                  child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      itemCount: stateB.rooms!.length,
                      itemBuilder: (BuildContext _, int index) {
                        return InkWell(
                          onTap: () {
                            context.read<SelectedRoomCubit>().change(index);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stateB.rooms![index].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (stateB.rooms![index].description.isNotEmpty)
                                  Text(
                                    stateB.rooms![index].description,
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          widget: AutoSizeText(
            stateA.room?.name ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            minFontSize: 6,
            maxFontSize: 12,
          ),
        );
      },
    );
  }

  Builder _buildCompanySelector() {
    return Builder(
      builder: (context) {
        final stateA = context.watch<OrganizationCubit>().state;
        final stateB = context.watch<SelectedOrganizationCubit>().state;

        return CustomSelectorData(
          onPressed: () => customDialog(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 16, bottom: 16),
                    child: Text(
                      '${Strings.organizations()}:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 440,
                  child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: stateA.organizations!.length,
                      itemBuilder: (BuildContext _, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: InkWell(
                            onTap: () {
                              context
                                  .read<SelectedOrganizationCubit>()
                                  .change(index);
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stateA.organizations![index].name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    stateA.organizations![index].description,
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          widget: AutoSizeText(
            stateB.organization?.name ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            minFontSize: 6,
            maxFontSize: 12,
          ),
        );
      },
    );
  }
}
