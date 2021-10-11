import 'package:deskable/cubit/cubit.dart';

import 'package:deskable/repositories/repositories.dart';

import 'package:deskable/screens/management/widget/box_organizations.dart';
import 'package:deskable/screens/management/widget/box_employees.dart';
import 'package:deskable/screens/management/widget/box_admins.dart';
import 'package:deskable/screens/management/widget/box_rooms.dart';
import 'package:deskable/screens/management/widget/monthly_booking.dart';

import 'package:deskable/utilities/strings.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        BlocProvider<OrganizationCubit>(
          create: (context) => OrganizationCubit(
            accountCubit: context.read<AccountCubit>(),
            organizationRepository: context.read<OrganizationRepository>(),
            accountRepository: context.read<AccountRepository>(),
            owner: true,
          ),
        ),
        BlocProvider<SelectedOrganizationCubit>(
          create: (context) => SelectedOrganizationCubit(
            accountCubit: context.read<AccountCubit>(),
            accountRepository: context.read<AccountRepository>(),
            organizationCubit: context.read<OrganizationCubit>(),
            organizationRepository: context.read<OrganizationRepository>(),
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
      ],
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: customAppBar(title: Strings.management()),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BoxOrganizations(),
                  SizedBox(width: 8),
                  BoxAdmins(),
                  SizedBox(width: 8),
                  BoxEmployees(),
                  SizedBox(width: 8),
                  BoxRooms(),
                  // SizedBox(width: 8),
                  // MonthlyBooking()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
