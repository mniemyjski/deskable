import 'package:deskable/cubit/account/account_cubit.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/screens/home/cubit/home_cubit.dart';
import 'package:deskable/screens/home/widgets/booking_in_room.dart';
import 'package:deskable/screens/home/widgets/room_builder.dart';
import 'package:deskable/utilities/languages.dart';
import 'package:deskable/widgets/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home';

  static Route route(bool fromSplashScreen) {
    if (fromSplashScreen) {
      return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, _, __) => HomeScreen(),
      );
    }

    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Room room = Room(
      companyId: 'qMaGsSVHIPMz9t5P6WrT',
      x: 8,
      y: 5,
      open: 6,
      close: 24,
      fields: [
        Field(id: 2, name: "1", path: 'resources/images/furnitures/computer.png'),
        Field(id: 3, name: "2", path: 'resources/images/furnitures/computer.png'),
        Field(id: 4, name: "3", path: 'resources/images/furnitures/computer.png'),
        Field(id: 5, name: "4", path: 'resources/images/furnitures/computer.png'),
        Field(id: 16, name: "5", rotation: 270, path: 'resources/images/furnitures/computer.png'),
        Field(id: 24, name: "6", rotation: 270, path: 'resources/images/furnitures/computer.png'),
        Field(id: 26, name: "7", rotation: 90, path: 'resources/images/furnitures/computer.png'),
        Field(id: 27, name: "8", rotation: 270, description: 'Stanowisko z laptopem', path: 'resources/images/furnitures/laptop.png'),
        Field(id: 32, name: "9", rotation: 270, description: 'Stanowisko z laptopem', path: 'resources/images/furnitures/laptop.png'),
        Field(id: 35, name: "10", rotation: 270, description: 'Stanowisko z laptopem', path: 'resources/images/furnitures/laptop.png'),
        Field(id: 34, name: "11", rotation: 90, description: 'Stanowisko z laptopem', path: 'resources/images/furnitures/laptop.png'),
        Field(id: 21, isEmpty: true),
        Field(id: 22, isEmpty: true),
        Field(id: 23, isEmpty: true),
        Field(id: 29, isEmpty: true),
        Field(id: 30, isEmpty: true),
        Field(id: 31, isEmpty: true),
        Field(id: 37, isEmpty: true),
        Field(id: 38, isEmpty: true),
        Field(id: 39, isEmpty: true),
      ],
      name: '1st floor, Narnia',
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Languages.home()),
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoomBuilder(room: room),
                SizedBox(width: 15),
                BookingInRoom(room: room),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: () {}, child: Text('create_room')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Company company = Company(name: "Canal+");
                          },
                          child: Text('create_company')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Booking booking = Booking(
                              dateCre: DateTime.now(),
                              companyId: 'qMaGsSVHIPMz9t5P6WrT',
                              roomId: 'i7nWMtg4KGz2NXc9znAf',
                              deskId: 5,
                              dateBook: DateTime.now(),
                              hoursBook: [6, 7, 8, 9, 10, 11, 12],
                            );
                          },
                          child: Text('create_booking')),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
