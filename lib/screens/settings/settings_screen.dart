import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/utilities/languages.dart';
import 'package:deskable/widgets/custom_drawer/custom_drawer.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const String routeName = '/settings';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => SettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: customAppBar(title: Languages.settings()),
        drawer: CustomDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomDropDownButton(
                name: Languages.locale_app(),
                value: context.locale.toString(),
                list: <String>['pl', 'en'],
                onChanged: (String? state) {
                  context.setLocale(Locale(state!));
                },
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    BlocBuilder<DarkModeCubit, bool>(
                      builder: (context, state) {
                        return Switch(
                          value: state,
                          onChanged: (state) {
                            context.read<DarkModeCubit>().change();
                          },
                        );
                      },
                    ),
                    Text(Languages.dark_mode()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
