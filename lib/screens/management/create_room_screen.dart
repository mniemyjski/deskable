import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/screens/management/cubit/create_room_cubit.dart';
import 'package:deskable/screens/management/widget/create_room_set_details.dart';
import 'package:deskable/screens/management/widget/dialog_edit_furniture.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_dialog.dart';
import 'package:deskable/widgets/custom_selector_data.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

class CreateRoomScreen extends StatelessWidget {
  final SelectedCompanyCubit selectedCompanyCubit;

  const CreateRoomScreen({Key? key, required this.selectedCompanyCubit}) : super(key: key);

  static const String routeName = '/create-room';

  static Route route(SelectedCompanyCubit selectedCompanyCubit) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => CreateRoomScreen(selectedCompanyCubit: selectedCompanyCubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateRoomCubit(
        accountCubit: context.read<AccountCubit>(),
        selectedCompanyCubit: selectedCompanyCubit,
        roomRepository: context.read<RoomRepository>(),
      ),
      child: BlocBuilder<CreateRoomCubit, CreateRoomState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      customDialog(
                        context,
                        BlocProvider.value(
                          value: BlocProvider.of<CreateRoomCubit>(context),
                          child: CreateRoomSetDetails(),
                        ),
                      );
                    },
                    icon: Icon(Icons.save)),
              ],
            ),
            bottomNavigationBar: Card(
              elevation: 1.0,
              child: Container(
                height: 125,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSelectorData(
                          onPressed: null,
                          widget: Text(state.x.toString()),
                          onPressedBack: () => context.read<CreateRoomCubit>().decreaseX(),
                          onPressedNext: () => context.read<CreateRoomCubit>().increaseX(),
                        ),
                        SizedBox(width: 16),
                        CustomSelectorData(
                          onPressed: null,
                          widget: Text(state.y.toString()),
                          onPressedBack: () => context.read<CreateRoomCubit>().decreaseY(),
                          onPressedNext: () => context.read<CreateRoomCubit>().increaseY(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Draggable<Furniture>(
                            data: Furniture(id: '', position: 0, type: EFurnitureType.computer),
                            child: Image.asset(Constants.computer(),
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.high,
                                color: Color.fromRGBO(255, 255, 255, 0.8),
                                colorBlendMode: BlendMode.modulate),
                            feedback: Image.asset(Constants.computer(),
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.high,
                                color: Color.fromRGBO(255, 255, 255, 0.8),
                                colorBlendMode: BlendMode.modulate),
                          ),
                          SizedBox(width: 8),
                          Draggable<Furniture>(
                            data: Furniture(id: '', position: 0, type: EFurnitureType.laptop),
                            child: Image.asset(
                              Constants.laptop(),
                              fit: BoxFit.fill,
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                              colorBlendMode: BlendMode.modulate,
                            ),
                            feedback: Image.asset(
                              Constants.laptop(),
                              fit: BoxFit.fill,
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                              colorBlendMode: BlendMode.modulate,
                            ),
                          ),
                          SizedBox(width: 8),
                          Draggable<Furniture>(
                            data: Furniture(id: '', position: 0, type: EFurnitureType.empty),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              width: 50,
                              height: 50,
                              child: Center(child: Text(Languages.empty())),
                            ),
                            feedback: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: state.x * 65,
                        height: state.y * 65,
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          crossAxisCount: state.x,
                          children: List.generate(state.x * state.y, (index) {
                            return DragTarget<Furniture>(
                              builder: (
                                BuildContext _,
                                List<dynamic> a,
                                List<dynamic> r,
                              ) {
                                final Furniture? furniture = state.furniture.firstWhereOrNull((element) => element.position == index);

                                if (furniture != null)
                                  return FieldInRoom(
                                    edit: true,
                                    furniture: furniture,
                                    onTap: () {
                                      if (furniture.type == EFurnitureType.empty) {
                                        context.read<CreateRoomCubit>().removeFurniture(furniture);
                                        return;
                                      }

                                      customDialog(
                                        context,
                                        BlocProvider.value(
                                            value: BlocProvider.of<CreateRoomCubit>(context),
                                            child: DialogEditFurniture(
                                              furniture: furniture,
                                            )),
                                      );
                                    },
                                  );

                                return FieldInRoom(
                                  furniture: null,
                                  onTap: null,
                                );
                              },
                              onAccept: (Furniture data) {
                                var uuid = Uuid();
                                context.read<CreateRoomCubit>().addFurniture(data.copyWith(id: uuid.v1(), position: index));
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
