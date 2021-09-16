import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/management/widget/search_field.dart';
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
  bool search = false;
  String _email = '';

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
                _buildHeader(),
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
        padding: const EdgeInsets.only(left: 8.0),
        child: BlocBuilder<SelectedOrganizationCubit, SelectedOrganizationState>(
          builder: (context, state) {
            if (state.status == ESelectedCompanyStatus.loading || state.status == ESelectedCompanyStatus.unknown) return Container();

            return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: state.company!.owners.length,
                itemBuilder: (BuildContext _, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(onTap: null, child: Text(state.company!.owners[index].name)),
                      ),
                      InkWell(
                        onTap: () => _onTap(context, state, index),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(Icons.remove_circle),
                        ),
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
    bool areYouSure = false;
    areYouSure = await areYouSureDialog(context);
    if (areYouSure) context.read<SelectedOrganizationCubit>().removeOwnerById(state.company!.owners[index].uid);
  }

  _buildHeader() {
    return search
        ? SearchField(
            onTapBack: () => setState(() => search = !search),
            onTapAdd: () async {
              setState(() => search = !search);
              bool succeed = false;
              succeed = await context.read<SelectedOrganizationCubit>().addOwnerByEmail(_email);
              if (!succeed) customFlashBar(context, Languages.there_is_no_such_email_address());
            },
            onTapRemove: () async {
              setState(() => search = !search);
              bool areYouSure = false;
              areYouSure = await areYouSureDialog(context);
              if (areYouSure) {
                bool succeed = false;
                succeed = await context.read<SelectedOrganizationCubit>().removeOwnerByEmail(_email);
                if (!succeed) customFlashBar(context, Languages.there_is_no_such_email_address());
              }
            },
            text: (String email) => _email = email,
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${Languages.admins()}:', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => setState(() => search = !search),
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}