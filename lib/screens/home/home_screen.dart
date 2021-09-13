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
        BlocProvider<CompanyCubit>(
          create: (context) => CompanyCubit(
            accountCubit: context.read<AccountCubit>(),
            companyRepository: context.read<CompanyRepository>(),
            accountRepository: context.read<AccountRepository>(),
          ),
        ),
        BlocProvider<SelectedCompanyCubit>(
          create: (context) => SelectedCompanyCubit(
            companyCubit: context.read<CompanyCubit>(),
            accountRepository: context.read<AccountRepository>(),
            companyRepository: context.read<CompanyRepository>(),
            accountCubit: context.read<AccountCubit>(),
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
          appBar: AppBar(
            title: Text(Languages.home()),
            actions: [
              IconButton(onPressed: () => null, icon: Icon(Icons.messenger_outline)),
              IconButton(onPressed: () => null, icon: Icon(Icons.notifications_none)),
            ],
          ),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  return BlocBuilder<CompanyCubit, CompanyState>(
                    builder: (context, state) {
                      if (state.status == ECompanyStatus.empty)
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(Languages.wait_for_the_invitation_or_create_your_own_company())),
                        );

                      if (state.status == ECompanyStatus.succeed)
                        return Responsive(
                          desktop: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BookingInRoom(),
                              SizedBox(width: 8),
                              RoomDisplay(),
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

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
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
