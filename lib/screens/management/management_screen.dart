import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/screens/home/widgets/booking_in_room.dart';
import 'package:deskable/screens/home/widgets/room_display.dart';
import 'package:deskable/screens/management/create_company_screen.dart';
import 'package:deskable/screens/management/create_room_screen.dart';
import 'package:deskable/utilities/languages.dart';
import 'package:deskable/utilities/responsive.dart';
import 'package:deskable/widgets/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({Key? key}) : super(key: key);
  static const String routeName = '/management';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => ManagementScreen(),
    );
  }

  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SelectedCompanyCubit>(
          create: (context) => SelectedCompanyCubit(
            companyCubit: context.read<CompanyCubit>(),
            companyRepository: context.read<CompanyRepository>(),
          ),
        ),
        BlocProvider<RoomCubit>(
          create: (context) => RoomCubit(
            accountCubit: context.read<AccountCubit>(),
            roomRepository: context.read<RoomRepository>(),
            selectedCompanyCubit: context.read<SelectedCompanyCubit>(),
          ),
        ),
        BlocProvider<SelectedRoomCubit>(
          create: (context) => SelectedRoomCubit(
            roomCubit: context.read<RoomCubit>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final stateA = context.watch<CompanyCubit>().state;
          final stateB = context.watch<SelectedCompanyCubit>().state;

          final stateC = context.watch<RoomCubit>().state;
          final stateD = context.watch<SelectedRoomCubit>().state;

          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBar(
                title: Text(Languages.management()),
              ),
              drawer: CustomDrawer(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${Languages.companies()}:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    onPressed: () => Navigator.of(context).pushNamed(CreateCompanyScreen.routeName),
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                              Divider(),
                              Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) => Divider(),
                                    itemCount: stateA.companies!.length,
                                    itemBuilder: (BuildContext _, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: InkWell(
                                          onTap: () {
                                            context.read<SelectedCompanyCubit>().change(stateA.companies![index]);
                                          },
                                          child: Text(
                                            stateA.companies![index].name,
                                            style: TextStyle(color: stateB.company!.id == stateA.companies![index].id ? Colors.blue : null),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${Languages.rooms()}:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    onPressed: () => Navigator.of(context).pushNamed(CreateRoomScreen.routeName),
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                              Divider(),
                              Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) => Divider(),
                                    itemCount: stateC.rooms!.length,
                                    itemBuilder: (BuildContext _, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            // context.read<SelectedCompanyCubit>().change(stateA.companies![index]);
                                          },
                                          child: Text(stateC.rooms![index].name),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              // Builder(
                              //   builder: (context) {
                              //     return Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: ElevatedButton(
                              //           onPressed: () {
                              //             var uuid = Uuid();
                              //
                              //             Room room = Room(
                              //               companyId: 'a0oIGtXYDHGV2wyE7p1r',
                              //               x: 8,
                              //               y: 5,
                              //               open: 6,
                              //               close: 24,
                              //               furniture: [
                              //                 Furniture(id: uuid.v1(), position: 2, name: "1", path: 'resources/images/furnitures/computer.png'),
                              //                 Furniture(id: uuid.v1(), position: 3, name: "2", path: 'resources/images/furnitures/computer.png'),
                              //                 Furniture(id: uuid.v1(), position: 4, name: "3", path: 'resources/images/furnitures/computer.png'),
                              //                 Furniture(id: uuid.v1(), position: 5, name: "4", path: 'resources/images/furnitures/computer.png'),
                              //                 Furniture(
                              //                     id: uuid.v1(), position: 16, name: "5", rotation: 270, path: 'resources/images/furnitures/computer.png'),
                              //                 Furniture(
                              //                     id: uuid.v1(), position: 24, name: "6", rotation: 270, path: 'resources/images/furnitures/computer.png'),
                              //                 Furniture(
                              //                     id: uuid.v1(), position: 26, name: "7", rotation: 90, path: 'resources/images/furnitures/computer.png'),
                              //                 Furniture(
                              //                     id: uuid.v1(),
                              //                     position: 27,
                              //                     name: "8",
                              //                     rotation: 270,
                              //                     description: 'Stanowisko z laptopem',
                              //                     path: 'resources/images/furnitures/laptop.png'),
                              //                 Furniture(
                              //                     id: uuid.v1(),
                              //                     position: 32,
                              //                     name: "9",
                              //                     rotation: 270,
                              //                     description: 'Stanowisko z laptopem',
                              //                     path: 'resources/images/furnitures/laptop.png'),
                              //                 Furniture(
                              //                     id: uuid.v1(),
                              //                     position: 35,
                              //                     name: "10",
                              //                     rotation: 270,
                              //                     description: 'Stanowisko z laptopem',
                              //                     path: 'resources/images/furnitures/laptop.png'),
                              //                 Furniture(
                              //                     id: uuid.v1(),
                              //                     position: 34,
                              //                     name: "11",
                              //                     rotation: 90,
                              //                     description: 'Stanowisko z laptopem',
                              //                     path: 'resources/images/furnitures/laptop.png'),
                              //                 Furniture(id: uuid.v1(), position: 21, isEmpty: true),
                              //                 Furniture(id: uuid.v1(), position: 22, isEmpty: true),
                              //                 Furniture(id: uuid.v1(), position: 23, isEmpty: true),
                              //                 Furniture(id: uuid.v1(), position: 29, isEmpty: true),
                              //                 Furniture(id: uuid.v1(), position: 30, isEmpty: true),
                              //                 Furniture(id: uuid.v1(), position: 31, isEmpty: true),
                              //                 Furniture(id: uuid.v1(), position: 37, isEmpty: true),
                              //                 Furniture(id: uuid.v1(), position: 38, isEmpty: true),
                              //                 Furniture(id: uuid.v1(), position: 39, isEmpty: true),
                              //               ],
                              //               id: uuid.v1(),
                              //               name: '1st floor, Narnia',
                              //             );
                              //
                              //             context.read<RoomCubit>().create(room);
                              //           },
                              //           child: Text('create_room')),
                              //     );
                              //   },
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: ElevatedButton(
                              //       onPressed: () {
                              //         Company company = Company(name: "Canal+");
                              //         context.read<CompanyCubit>().create(company);
                              //       },
                              //       child: Text('create_company')),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: ElevatedButton(
                              //       onPressed: () {
                              //         Booking booking = Booking(
                              //           dateCre: DateTime.now(),
                              //           companyId: 'a0oIGtXYDHGV2wyE7p1r',
                              //           roomId: 'Yly4qvn87SswDrYmb7Qe',
                              //           deskId: 5,
                              //           dateBook: DateTime.now(),
                              //           hoursBook: [6, 7, 8, 9, 10, 11, 12],
                              //         );
                              //         context.read<BookingCubit>().create(booking);
                              //       },
                              //       child: Text('create_booking')),
                              // ),
                            ],
                          )
                        ],
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
