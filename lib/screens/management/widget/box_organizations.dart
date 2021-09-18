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
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${Languages.organizations()}:', style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }

  Builder _buildListView() {
    return Builder(
      builder: (context) {
        final stateA = context.watch<OrganizationCubit>().state;
        final stateB = context.watch<SelectedOrganizationCubit>().state;

        return Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: stateA.companies!.length,
              itemBuilder: (BuildContext _, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => context.read<SelectedOrganizationCubit>().change(index),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            stateA.companies![index].name,
                            style: TextStyle(color: stateB.company!.id == stateA.companies![index].id ? Colors.blue : null),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          customDialog(
                            context,
                            BlocProvider.value(
                              value: BlocProvider.of<OrganizationCubit>(context),
                              child: CreateOrganizations(company: stateA.companies![index]),
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

  Future<void> _onTap(BuildContext context, OrganizationState stateA, int index) async {
    bool areYouSure = false;
    areYouSure = await areYouSureDialog(context);

    if (areYouSure) context.read<OrganizationCubit>().delete(stateA.companies![index]);
  }
}
