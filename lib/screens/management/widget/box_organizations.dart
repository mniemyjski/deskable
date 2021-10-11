import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/screens/management/widget/create_organization.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxOrganizations extends StatelessWidget {
  const BoxOrganizations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 500,
        width: 220,
        child: Column(
          children: [
            _buildHeader(context),
            Divider(),
            _buildListView(),
          ],
        ),
      ),
    );
  }

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${Strings.organizations()}:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () {
              customDialog(
                context,
                BlocProvider.value(
                  value: BlocProvider.of<OrganizationCubit>(context),
                  child: CreateOrganizations(),
                ),
              );
            },
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
    );
  }

  Builder _buildListView() {
    return Builder(
      builder: (context) {
        final stateA = context.watch<OrganizationCubit>().state;
        final stateB = context.watch<SelectedOrganizationCubit>().state;

        return Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Divider(),
                  ),
              itemCount: stateA.organizations!.length,
              itemBuilder: (BuildContext _, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => context
                              .read<SelectedOrganizationCubit>()
                              .change(index),
                          child: Text(
                            stateA.organizations![index].name,
                            style: TextStyle(
                                color: stateB.organization!.id ==
                                        stateA.organizations![index].id
                                    ? Colors.blue
                                    : null),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          customDialog(
                            context,
                            BlocProvider.value(
                              value:
                                  BlocProvider.of<OrganizationCubit>(context),
                              child: CreateOrganizations(
                                  organization: stateA.organizations![index]),
                            ),
                          );
                        },
                        child: Icon(Icons.edit),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: InkWell(
                          onTap: () => _onTap(context, stateA, index),
                          child: Icon(Icons.remove_circle),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }

  Future<void> _onTap(
      BuildContext context, OrganizationState stateA, int index) async {
    bool areYouSure = false;
    areYouSure = await areYouSureDialog(context);

    if (areYouSure)
      context.read<OrganizationCubit>().delete(stateA.organizations![index]);
  }
}
