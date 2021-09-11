import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/management/widget/search_field.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxOwners extends StatefulWidget {
  const BoxOwners({Key? key}) : super(key: key);

  @override
  State<BoxOwners> createState() => _BoxOwnersState();
}

class _BoxOwnersState extends State<BoxOwners> {
  bool search = false;
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          search
              ? SearchField(
                  onTapBack: () => setState(() => search = !search),
                  onTapAdd: () async {
                    setState(() => search = !search);
                    bool succeed = false;
                    succeed = await context.read<SelectedCompanyCubit>().addOwner(_email);
                    if (!succeed) customFlashBar(context, Languages.there_is_no_such_email_address());
                  },
                  onTapRemove: () async {
                    setState(() => search = !search);
                    bool succeed = false;
                    succeed = await context.read<SelectedCompanyCubit>().removeOwnerByEmail(_email);
                    if (!succeed) customFlashBar(context, Languages.there_is_no_such_email_address());
                  },
                  text: (String email) => _email = email,
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${Languages.owners()}:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                ),
          Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: BlocBuilder<SelectedCompanyCubit, SelectedCompanyState>(
                builder: (context, state) {
                  if (state.status == ESelectedCompanyStatus.loading || state.status == ESelectedCompanyStatus.unknown) return Container();

                  return ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: state.company!.owners?.length ?? 0,
                      itemBuilder: (BuildContext _, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(state.company!.owners![index].name),
                                  )),
                            ),
                            InkWell(
                              onTap: () => context.read<SelectedCompanyCubit>().removeOwnerById(state.company!.owners![index]),
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
            ),
          ),
        ],
      ),
    );
  }
}
