import 'package:deskable/cubit/company/employees_cubit.dart';
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
          width: 300,
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
                search
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
                          bool succeed = false;
                          succeed = await context.read<SelectedCompanyCubit>().removeEmployeeByEmail(_email);
                          if (!succeed) customFlashBar(context, Languages.there_is_no_such_email_address());
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
                      ),
                Divider(),
                Expanded(
                  child: BlocBuilder<SelectedCompanyCubit, SelectedCompanyState>(
                    builder: (context, state) {
                      if (state.status == ESelectedCompanyStatus.loading || state.status == ESelectedCompanyStatus.unknown) return Container();

                      return ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: state.company!.employees?.length ?? 0,
                          itemBuilder: (BuildContext _, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(state.company!.employees![index].name),
                                      )),
                                ),
                                InkWell(
                                  onTap: () => context.read<SelectedCompanyCubit>().removeEmployeeById(state.company!.employees![index].uid),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.remove_circle),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  ),

                  // child: BlocBuilder<EmployeesCubit, EmployeesState>(
                  //   builder: (context, state) {
                  //     return ListView.separated(
                  //         separatorBuilder: (context, index) => Divider(),
                  //         itemCount: state.accounts.length,
                  //         itemBuilder: (BuildContext _, int index) {
                  //           return Padding(
                  //             padding: const EdgeInsets.all(4.0),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Expanded(
                  //                   child: InkWell(
                  //                       onTap: () {},
                  //                       child: Padding(
                  //                         padding: const EdgeInsets.all(8.0),
                  //                         child: Text(state.accounts[index].name),
                  //                       )),
                  //                 ),
                  //                 InkWell(
                  //                   onTap: () async {
                  //                     bool areYouSure = false;
                  //                     areYouSure = await areYouSureDialog(context);
                  //
                  //                     if (areYouSure) context.read<EmployeesCubit>().removeFromCompanyById(state.accounts[index].uid);
                  //                   },
                  //                   child: Icon(Icons.remove_circle),
                  //                 ),
                  //               ],
                  //             ),
                  //           );
                  //         });
                  //   },
                  // ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
