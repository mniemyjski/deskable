import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/management/widget/search_dialog.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxAdmins extends StatefulWidget {
  const BoxAdmins({Key? key}) : super(key: key);

  @override
  State<BoxAdmins> createState() => _BoxAdminsState();
}

class _BoxAdminsState extends State<BoxAdmins> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedOrganizationCubit, SelectedOrganizationState>(
      builder: (context, state) {
        if (state.status != ESelectedCompanyStatus.succeed) return Container();

        return Card(
          child: Container(
            height: 500,
            width: 220,
            child: Column(
              children: [
                _buildHeader(state.organization!.admins),
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: BlocBuilder<SelectedOrganizationCubit, SelectedOrganizationState>(
          builder: (context, state) {
            if (state.status == ESelectedCompanyStatus.loading || state.status == ESelectedCompanyStatus.unknown) return Container();

            return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: state.organization!.admins.length,
                itemBuilder: (BuildContext _, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(onTap: null, child: Text(state.organization!.admins[index].name)),
                      ),
                      InkWell(
                        onTap: () => _onTap(context, state, index),
                        child: Icon(Icons.remove_circle),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }

  Future<void> _onTap(BuildContext context, SelectedOrganizationState state, int index) async {
    bool isPossible = await context.read<SelectedOrganizationCubit>().isPossible(state.organization!.admins[index].uid);

    if (isPossible) {
      bool areYouSure = false;
      areYouSure = await areYouSureDialog(context);
      if (areYouSure) context.read<SelectedOrganizationCubit>().removeOwnerById(state.organization!.admins[index].uid);
    } else {
      customFlashBar(context, Languages.you_can_not_do_it());
    }
  }

  _buildHeader(List<Account> admins) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${Languages.admins()}:', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  customDialog(
                      context,
                      SearchDialog(
                        alreadyAccountAdded: admins,
                        onTapAdd: (Account account) async {
                          await context.read<SelectedOrganizationCubit>().addAdmin(account);
                          Navigator.pop(context);
                        },
                        onTapRemove: (Account account) async {
                          bool isPossible = await context.read<SelectedOrganizationCubit>().isPossible(account.uid);

                          if (isPossible) {
                            bool areYouSure = false;
                            areYouSure = await areYouSureDialog(context);
                            if (areYouSure) {
                              context.read<SelectedOrganizationCubit>().removeOwnerById(account.uid);
                              Navigator.pop(context);
                            }
                          } else {
                            customFlashBar(context, Languages.you_can_not_do_it());
                          }
                        },
                        onTapMany: (List<Account> accounts) async {
                          for (final a in accounts) {
                            await context.read<SelectedOrganizationCubit>().addAdmin(a);
                          }
                          Navigator.pop(context);
                        },
                      ));
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
