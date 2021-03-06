import 'package:bot_toast/bot_toast.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/utilities/strings.dart';
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
        appBar: customAppBar(title: Strings.settings()),
        drawer: CustomDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300),
                child: CustomDropDownButton(
                  name: Strings.locale_app(),
                  value: context.locale.toString(),
                  list: <String>['pl', 'en'],
                  onChanged: (String? state) {
                    context.setLocale(Locale(state!));
                  },
                ),
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
                    Text(
                      Strings.dark_mode(),
                      style: TextStyle(color: Colors.white),
                    ),
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
