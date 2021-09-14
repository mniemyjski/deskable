import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/screens/management/widget/create_company.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxCompanies extends StatelessWidget {
  const BoxCompanies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            _buildHeader(context),
            Divider(),
            _buildListView(),
          ],
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${Languages.companies()}:', style: TextStyle(fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: () {
            customDialog(
              context,
              BlocProvider.value(
                value: BlocProvider.of<CompanyCubit>(context),
                child: CreateCompany(),
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
        final stateA = context.watch<CompanyCubit>().state;
        final stateB = context.watch<SelectedCompanyCubit>().state;

        return Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: stateA.companies!.length,
              itemBuilder: (BuildContext _, int index) {
                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context.read<SelectedCompanyCubit>().change(stateA.companies![index]);
                          },
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
                        padding: const EdgeInsets.all(8.0),
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

  Future<void> _onTap(BuildContext context, CompanyState stateA, int index) async {
    bool areYouSure = false;
    areYouSure = await areYouSureDialog(context);

    if (areYouSure) context.read<CompanyCubit>().delete(stateA.companies![index]);
  }
}
