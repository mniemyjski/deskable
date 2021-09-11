import 'package:deskable/cubit/company/company_employees_cubit.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/screens/home/widgets/booking_in_room.dart';
import 'package:deskable/screens/home/widgets/room_display.dart';
import 'package:deskable/screens/management/create_room_screen.dart';
import 'package:deskable/screens/management/widget/box_companies.dart';
import 'package:deskable/screens/management/widget/box_employees.dart';
import 'package:deskable/screens/management/widget/box_owners.dart';
import 'package:deskable/screens/management/widget/box_rooms.dart';
import 'package:deskable/utilities/enums.dart';
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
            accountRepository: context.read<AccountRepository>(),
            companyCubit: context.read<CompanyCubit>(),
            companyRepository: context.read<CompanyRepository>(),
          ),
        ),
        BlocProvider<CompanyEmployeesCubit>(
          create: (context) => CompanyEmployeesCubit(
            accountRepository: context.read<AccountRepository>(),
            selectedCompanyCubit: context.read<SelectedCompanyCubit>(),
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
      child: WillPopScope(
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
                  BoxCompanies(),
                  SizedBox(width: 8),
                  BoxRooms(),
                  SizedBox(width: 8),
                  BoxOwners(),
                  SizedBox(width: 8),
                  BoxEmployees(),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
