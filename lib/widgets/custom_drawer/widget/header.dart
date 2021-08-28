import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/screens/screens.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorDark.withOpacity(0.6),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AccountEditScreen.routeName);
            },
            child: Stack(children: <Widget>[
              Positioned(
                bottom: 40.0,
                left: 16.0,
                child: BlocBuilder<AccountCubit, AccountState>(
                  builder: (context, state) {
                    if (state.status == EAccountStatus.created) return CustomAvatar(url: state.account!.photoUrl);
                    return CustomAvatar();
                  },
                ),
              ),
              Positioned(
                  bottom: 8.0,
                  left: 16.0,
                  child: BlocBuilder<AccountCubit, AccountState>(
                    builder: (context, state) {
                      if (state.status == EAccountStatus.created)
                        return Text(
                          state.account!.name,
                          style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
                        );
                      return Container();
                    },
                  )),
            ]),
          )),
    );
  }
}
