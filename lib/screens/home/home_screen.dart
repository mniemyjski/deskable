import 'package:deskable/cubit/company/company_cubit.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/repositories/repositories.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<SelectedCompanyCubit>(
          create: (context) => SelectedCompanyCubit(
            companyCubit: context.read<CompanyCubit>(),
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
        BlocProvider<SelectedDateCubit>(
          create: (context) => SelectedDateCubit(),
        ),
        BlocProvider<BookingCubit>(
          create: (context) => BookingCubit(
            accountCubit: context.read<AccountCubit>(),
            bookingRepository: context.read<BookingRepository>(),
            selectedRoomCubit: context.read<SelectedRoomCubit>(),
            selectedDateCubit: context.read<SelectedDateCubit>(),
          ),
        ),
      ],
      child: WillPopScope(
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
      ),
    );
  }
}
