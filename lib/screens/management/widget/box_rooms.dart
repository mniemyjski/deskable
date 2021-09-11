import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/screens/screens.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxRooms extends StatelessWidget {
  const BoxRooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 200,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${Languages.rooms()}:', style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(CreateRoomScreen.routeName, arguments: BlocProvider.of<SelectedCompanyCubit>(context)),
                  icon: Icon(Icons.add_circle),
                ),
              ],
            ),
            Divider(),
            Builder(
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
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  // context.read<SelectedCompanyCubit>().change(stateA.companies![index]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(stateA.rooms![index].name),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  bool areYouSure = false;
                                  areYouSure = await areYouSureDialog(context);

                                  if (areYouSure) context.read<RoomCubit>().delete(stateA.rooms![index]);
                                },
                                child: Icon(Icons.remove_circle),
                              ),
                            ),
                          ],
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
