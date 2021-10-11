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

class CreateRoomScreenArguments {
  final SelectedOrganizationCubit selectedOrganizationCubit;
  final Room? room;

  CreateRoomScreenArguments(
      {required this.selectedOrganizationCubit, this.room});
}

class CreateRoomScreen extends StatelessWidget {
  final Room? room;

  const CreateRoomScreen({Key? key, this.room}) : super(key: key);

  static const String routeName = '/create-room';

  static Route route(CreateRoomScreenArguments args) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider.value(
        value: args.selectedOrganizationCubit,
        child: CreateRoomScreen(room: args.room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateRoomCubit(
        accountCubit: context.read<AccountCubit>(),
        selectedCompanyCubit: context.read<SelectedOrganizationCubit>(),
        roomRepository: context.read<RoomRepository>(),
      )..init(room),
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
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      width: 280,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomSelectorData(
                              onPressed: null,
                              widget: Text(state.room.x.toString()),
                              onPressedBack: () {
                                if (state.room.furniture.isEmpty) {
                                  context.read<CreateRoomCubit>().decreaseX();
                                } else {
                                  customFlashBar(
                                      Strings.before_remove_furnitures());
                                }
                              },
                              onPressedNext: () =>
                                  context.read<CreateRoomCubit>().increaseX(),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: CustomSelectorData(
                              onPressed: null,
                              widget: Text(state.room.y.toString()),
                              onPressedBack: () {
                                if (state.room.furniture.isEmpty) {
                                  context.read<CreateRoomCubit>().decreaseY();
                                } else {
                                  customFlashBar(
                                      Strings.before_remove_furnitures());
                                }
                              },
                              onPressedNext: () =>
                                  context.read<CreateRoomCubit>().increaseY(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Draggable<Furniture>(
                            data: Furniture(
                                id: '',
                                position: -1,
                                type: EFurnitureType.computer),
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
                            data: Furniture(
                                id: '',
                                position: -1,
                                type: EFurnitureType.laptop),
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
                            data: Furniture(
                                id: '',
                                position: -1,
                                type: EFurnitureType.empty),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              width: 50,
                              height: 50,
                              child: Center(child: Text(Strings.empty())),
                            ),
                            feedback: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
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
                        width: state.room.x * 65,
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          crossAxisCount: state.room.x,
                          children: List.generate(state.room.x * state.room.y,
                              (index) {
                            return DragTarget<Furniture>(
                              builder: (
                                BuildContext _,
                                List<dynamic> a,
                                List<dynamic> r,
                              ) {
                                final Furniture? furniture =
                                    state.room.furniture.firstWhereOrNull(
                                        (element) => element.position == index);

                                if (furniture != null &&
                                    furniture.type != EFurnitureType.empty)
                                  return Draggable<Furniture>(
                                    data: furniture,
                                    feedback: RotationTransition(
                                      turns: AlwaysStoppedAnimation(
                                          furniture.rotation / 360),
                                      child: Image.asset(furniture.path(),
                                          fit: BoxFit.fill,
                                          filterQuality: FilterQuality.high,
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.8),
                                          colorBlendMode: BlendMode.modulate),
                                    ),
                                    child: FieldInRoom(
                                      edit: true,
                                      furniture: furniture,
                                      onTap: () {
                                        customDialog(
                                          context,
                                          BlocProvider.value(
                                              value: BlocProvider.of<
                                                  CreateRoomCubit>(context),
                                              child: DialogEditFurniture(
                                                furniture: furniture,
                                              )),
                                        );
                                      },
                                    ),
                                  );

                                if (furniture != null &&
                                    furniture.type == EFurnitureType.empty)
                                  return FieldInRoom(
                                    edit: true,
                                    furniture: furniture,
                                    onTap: () => context
                                        .read<CreateRoomCubit>()
                                        .removeFurniture(furniture),
                                  );

                                return FieldInRoom(
                                  furniture: null,
                                  onTap: null,
                                );
                              },
                              onAccept: (Furniture furniture) {
                                if (context
                                    .read<CreateRoomCubit>()
                                    .isFree(index)) {
                                  if (furniture.position == -1) {
                                    var uuid = Uuid();
                                    context
                                        .read<CreateRoomCubit>()
                                        .addFurniture(furniture.copyWith(
                                            id: uuid.v1(), position: index));
                                  } else {
                                    Furniture oldFurniture = furniture;
                                    context
                                        .read<CreateRoomCubit>()
                                        .removeFurniture(oldFurniture);
                                    context
                                        .read<CreateRoomCubit>()
                                        .addFurniture(furniture.copyWith(
                                            position: index));
                                  }
                                }
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
