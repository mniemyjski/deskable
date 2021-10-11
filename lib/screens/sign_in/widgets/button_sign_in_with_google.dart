import 'package:deskable/screens/sign_in/cubit/sign_in_cubit.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonSignInWithGoogle extends StatelessWidget {
  const ButtonSignInWithGoogle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        textColor: Colors.black87,
        backgroundColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Image.asset(Constants.resources_google()),
            ),
            Text(
              Strings.sign_in_with_google(),
              style: TextStyle(color: Colors.black87),
            ),
            Container(),
          ],
        ),
        onPressed: () => context.read<SignInCubit>().signInWithGoogle());
  }
}
