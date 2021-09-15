import 'package:deskable/cubit/cubit.dart';

import 'package:deskable/repositories/repositories.dart';

import 'package:deskable/screens/management/widget/box_companies.dart';
import 'package:deskable/screens/management/widget/box_employees.dart';
import 'package:deskable/screens/management/widget/box_owners.dart';
import 'package:deskable/screens/management/widget/box_rooms.dart';

import 'package:deskable/utilities/languages.dart';
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
        BlocProvider<CompanyCubit>(
          create: (context) => CompanyCubit(
            accountCubit: context.read<AccountCubit>(),
            companyRepository: context.read<CompanyRepository>(),
            accountRepository: context.read<AccountRepository>(),
            owner: true,
          ),
        ),
        BlocProvider<SelectedCompanyCubit>(
          create: (context) => SelectedCompanyCubit(
            accountCubit: context.read<AccountCubit>(),
            accountRepository: context.read<AccountRepository>(),
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
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: customAppBar(title: Languages.management()),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BoxCompanies(),
                  SizedBox(width: 8),
                  BoxOwners(),
                  SizedBox(width: 8),
                  BoxEmployees(),
                  SizedBox(width: 8),
                  SizedBox(width: 8),
                  BoxRooms(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
