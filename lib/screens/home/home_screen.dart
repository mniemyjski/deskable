import 'package:deskable/cubit/organization/organization_cubit.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/screens/home/widgets/booking_in_room.dart';
import 'package:deskable/screens/home/widgets/incoming_booking.dart';
import 'package:deskable/screens/home/widgets/room_display.dart';
import 'package:deskable/screens/screens.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:deskable/utilities/strings.dart';
import 'package:deskable/utilities/responsive.dart';
import 'package:deskable/widgets/custom_drawer/custom_drawer.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home';

  static Route route(bool fromSplashScreen) {
    // if (fromSplashScreen) {
    //   return PageRouteBuilder(
    //     settings: const RouteSettings(name: routeName),
    //     transitionDuration: const Duration(seconds: 0),
    //     pageBuilder: (context, _, __) => HomeScreen(),
    //   );
    // }

    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrganizationCubit>(
          create: (context) => OrganizationCubit(
            accountCubit: context.read<AccountCubit>(),
            organizationRepository: context.read<OrganizationRepository>(),
            accountRepository: context.read<AccountRepository>(),
          ),
        ),
        BlocProvider<SelectedOrganizationCubit>(
          create: (context) => SelectedOrganizationCubit(
            organizationCubit: context.read<OrganizationCubit>(),
            accountRepository: context.read<AccountRepository>(),
            organizationRepository: context.read<OrganizationRepository>(),
            accountCubit: context.read<AccountCubit>(),
          ),
        ),
        BlocProvider<RoomCubit>(
          create: (context) => RoomCubit(
            accountCubit: context.read<AccountCubit>(),
            roomRepository: context.read<RoomRepository>(),
            selectedOrganizationCubit:
                context.read<SelectedOrganizationCubit>(),
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
            accountRepository: context.read<AccountRepository>(),
            bookingRepository: context.read<BookingRepository>(),
            selectedRoomCubit: context.read<SelectedRoomCubit>(),
            selectedDateCubit: context.read<SelectedDateCubit>(),
          ),
        ),
      ],
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: customAppBar(title: Strings.home()),
          drawer: CustomDrawer(),
          body: Builder(
            builder: (context) {
              return BlocBuilder<OrganizationCubit, OrganizationState>(
                builder: (context, state) {
                  if (state.status == ECompanyStatus.empty)
                    return Scaffold(
                        body: Center(
                      child: ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(ManagementScreen.routeName),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Strings
                                  .wait_for_the_invitation_or_create_your_own_organization(),
                              style: TextStyle(fontSize: 14),
                            ),
                          )),
                    ));

                  if (state.status == ECompanyStatus.succeed)
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Responsive(
                          desktop: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  BookingInRoom(),
                                  IncomingBooking(),
                                ],
                              ),
                              SizedBox(width: 8),
                              RoomDisplay(),
                            ],
                          ),
                          mobile: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RoomDisplay(),
                                SizedBox(height: 4),
                                BookingInRoom(),
                                SizedBox(height: 4),
                                IncomingBooking(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );

                  return const Scaffold(
                      body: Center(
                    child: CustomLoadingWidget(),
                  ));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
