import 'package:deskable/cubit/company/company_cubit.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/screens/home/widgets/booking_in_room.dart';
import 'package:deskable/screens/home/widgets/room_display.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:deskable/utilities/languages.dart';
import 'package:deskable/utilities/responsive.dart';
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Languages.home()),
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                return Responsive(
                  desktop: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoomDisplay(),
                      SizedBox(width: 15),
                      BookingInRoom(),
                    ],
                  ),
                  mobile: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoomDisplay(),
                      SizedBox(height: 4),
                      BookingInRoom(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
