import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/screens/management/widget/search_field.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxEmployees extends StatefulWidget {
  const BoxEmployees({Key? key}) : super(key: key);

  @override
  State<BoxEmployees> createState() => _BoxEmployeesState();
}

class _BoxEmployeesState extends State<BoxEmployees> {
  bool search = false;
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedCompanyCubit, SelectedCompanyState>(
      builder: (context, state) {
        if (state.status != ESelectedCompanyStatus.succeed) return Container();

        return Container(
          height: 500,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
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
    return Expanded(child: BlocBuilder<SelectedCompanyCubit, SelectedCompanyState>(
      builder: (context, state) {
        if (state.status == ESelectedCompanyStatus.loading || state.status == ESelectedCompanyStatus.unknown) return Container();

        return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: state.company!.employees.length,
            itemBuilder: (BuildContext _, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(state.company!.employees[index].name),
                        )),
                  ),
                  InkWell(
                    onTap: () => _onTap(context, state, index),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.remove_circle),
                    ),
                  ),
                ],
              );
            });
      },
    ));
  }

  Future<void> _onTap(BuildContext context, SelectedCompanyState state, int index) async {
    bool areYouSure = false;
    areYouSure = await areYouSureDialog(context);
    if (areYouSure) context.read<SelectedCompanyCubit>().removeEmployeeById(state.company!.employees[index].uid);
  }

  _buildHeader() {
    return search
        ? SearchField(
            onTapBack: () => setState(() => search = !search),
            onTapAdd: () async {
              setState(() => search = !search);
              bool succeed = false;
              succeed = await context.read<SelectedCompanyCubit>().addEmployeeByEmail(_email);
              if (!succeed) customFlashBar(context, Languages.there_is_no_such_email_address());
            },
            onTapRemove: () async {
              setState(() => search = !search);
              bool areYouSure = false;
              areYouSure = await areYouSureDialog(context);
              if (areYouSure) {
                bool succeed = false;
                succeed = await context.read<SelectedCompanyCubit>().removeEmployeeByEmail(_email);
                if (!succeed) customFlashBar(context, Languages.there_is_no_such_email_address());
              }
            },
            text: (String email) => _email = email,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${Languages.users()}:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => search = !search),
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ],
          );
  }
}
