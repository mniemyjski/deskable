import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/cubit/selected/selected_organization_cubit.dart';
import 'package:deskable/screens/screens.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxRooms extends StatelessWidget {
  const BoxRooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedOrganizationCubit, SelectedOrganizationState>(
      builder: (context, state) {
        if (state.status != ESelectedCompanyStatus.succeed) return Container();

        return Card(
          child: Container(
            height: 500,
            width: 220,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                children: [
                  _buildHeader(context),
                  Divider(),
                  _buildListView(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${Languages.rooms()}:', style: TextStyle(fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed(
            CreateRoomScreen.routeName,
            arguments: CreateRoomScreenArguments(
              selectedOrganizationCubit: context.read<SelectedOrganizationCubit>(),
            ),
          ),
          icon: Icon(Icons.add_circle),
        ),
      ],
    );
  }

  Builder _buildListView() {
    return Builder(
      builder: (context) {
        final stateA = context.watch<RoomCubit>().state;

        return Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: stateA.rooms!.length,
              itemBuilder: (BuildContext _, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(stateA.rooms![index].name)),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            CreateRoomScreen.routeName,
                            arguments: CreateRoomScreenArguments(
                              selectedOrganizationCubit: context.read<SelectedOrganizationCubit>(),
                              room: stateA.rooms![index],
                            ),
                          );
                        },
                        child: Icon(Icons.edit),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => _onTap(context, stateA, index),
                        child: Icon(Icons.remove_circle),
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }

  Future<void> _onTap(BuildContext context, RoomState stateA, int index) async {
    bool areYouSure = false;
    areYouSure = await areYouSureDialog(context);

    if (areYouSure) context.read<RoomCubit>().delete(stateA.rooms![index]);
  }
}
