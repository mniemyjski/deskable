import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/management/widget/search_dialog.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxEmployees extends StatefulWidget {
  const BoxEmployees({Key? key}) : super(key: key);

  @override
  State<BoxEmployees> createState() => _BoxEmployeesState();
}

class _BoxEmployeesState extends State<BoxEmployees> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedOrganizationCubit, SelectedOrganizationState>(
      builder: (context, state) {
        if (state.status != ESelectedOrganizationStatus.succeed)
          return Container();

        return Card(
          child: Container(
            height: 500,
            width: 220,
            child: Column(
              children: [
                _buildHeader(state.organization!.users),
                Divider(),
                _buildListView(),
              ],
            ),
          ),
        );
      },
    );
  }

  Expanded _buildListView() {
    return Expanded(child:
        BlocBuilder<SelectedOrganizationCubit, SelectedOrganizationState>(
      builder: (context, state) {
        if (state.status == ESelectedOrganizationStatus.loading ||
            state.status == ESelectedOrganizationStatus.unknown)
          return Container();

        return ListView.separated(
            separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Divider(),
                ),
            itemCount: state.organization!.users.length,
            itemBuilder: (BuildContext _, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: null,
                          child: Text(state.organization!.users[index].name)),
                    ),
                    InkWell(
                      onTap: () => _onTap(context, state, index),
                      child: Icon(Icons.remove_circle),
                    ),
                  ],
                ),
              );
            });
      },
    ));
  }

  Future<void> _onTap(
      BuildContext context, SelectedOrganizationState state, int index) async {
    bool areYouSure = false;
    areYouSure = await areYouSureDialog(context);
    if (areYouSure)
      context
          .read<SelectedOrganizationCubit>()
          .removeEmployeeById(state.organization!.users[index].uid);
  }

  _buildHeader(List<Account> emp) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${Strings.users()}:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  customDialog(
                    context,
                    SearchDialog(
                      alreadyAccountAdded: emp,
                      onTapAdd: (Account account) async {
                        await context
                            .read<SelectedOrganizationCubit>()
                            .addEmployee(account);
                        Navigator.pop(context);
                      },
                      onTapRemove: (Account account) async {
                        bool areYouSure = false;
                        areYouSure = await areYouSureDialog(context);
                        if (areYouSure) {
                          await context
                              .read<SelectedOrganizationCubit>()
                              .removeEmployeeById(account.uid);
                          Navigator.pop(context);
                        }
                      },
                      onTapMany: (List<Account> accounts) async {
                        Logger().wtf(accounts);
                        for (final a in accounts) {
                          await context
                              .read<SelectedOrganizationCubit>()
                              .addEmployee(a);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
