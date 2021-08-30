import 'package:deskable/bloc/auth/auth_bloc.dart';
import 'package:deskable/screens/screens.dart';
import 'package:deskable/screens/settings/settings_screen.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_drawer/widget/header.dart';
import 'package:deskable/widgets/custom_drawer/widget/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Header(),
          Item(
            icon: Icons.home,
            text: Languages.home(),
            onTap: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName, arguments: false);
            },
          ),
          Item(
            icon: FontAwesomeIcons.building,
            text: Languages.management(),
            onTap: () {
              Navigator.of(context).pushNamed(ManagementScreen.routeName);
            },
          ),
          Item(
            icon: Icons.settings,
            text: Languages.settings(),
            onTap: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
          Divider(),
          Item(
            icon: FontAwesomeIcons.question,
            text: Languages.help(),
            onTap: () {
              Navigator.of(context).pushNamed(IntroScreen.routeName);
            },
          ),
          Item(
            icon: Icons.exit_to_app,
            text: Languages.sign_out(),
            onTap: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
    );
  }

  // Widget _header(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).primaryColor,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Theme.of(context).primaryColorDark.withOpacity(0.6),
  //           spreadRadius: 1,
  //           blurRadius: 1,
  //           offset: Offset(0, 1),
  //         ),
  //       ],
  //     ),
  //     child: DrawerHeader(
  //         margin: EdgeInsets.zero,
  //         padding: EdgeInsets.zero,
  //         decoration: BoxDecoration(color: Theme.of(context).primaryColor),
  //         child: GestureDetector(
  //           onTap: () {},
  //           child: Stack(children: <Widget>[
  //             Positioned(
  //               bottom: 40.0,
  //               left: 16.0,
  //               child: CircleAvatar(
  //                 radius: 55,
  //                 backgroundColor: Colors.black12,
  //                 child: CachedNetworkImage(
  //                   imageUrl: "",
  //                   imageBuilder: (context, imageProvider) => Container(
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       border: Border.all(color: Colors.black87, width: 1.0),
  //                       image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
  //                     ),
  //                   ),
  //                   placeholder: (context, url) => CircularProgressIndicator(),
  //                   errorWidget: (context, url, error) => Icon(
  //                     Icons.account_circle,
  //                     size: 110,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //                 bottom: 8.0,
  //                 left: 16.0,
  //                 child: Text(
  //                   "",
  //                   style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
  //                 )),
  //           ]),
  //         )),
  //   );
  // }

  // Widget _drawerItem({
  //   required IconData icon,
  //   required String text,
  //   required GestureTapCallback onTap,
  //   bool inactive = false,
  // }) {
  //   return ListTile(
  //     title: Row(
  //       children: <Widget>[
  //         Icon(icon),
  //         Padding(
  //           padding: EdgeInsets.only(left: 8.0),
  //           child: Text(text, style: inactive ? TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey) : null),
  //         )
  //       ],
  //     ),
  //     onTap: onTap,
  //   );
  // }
}
