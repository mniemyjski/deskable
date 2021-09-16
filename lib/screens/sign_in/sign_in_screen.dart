import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/screens/sign_in/cubit/sign_in_cubit.dart';
import 'package:deskable/screens/sign_in/widgets/button_sign_in_with_email.dart';
import 'package:deskable/screens/sign_in/widgets/button_sign_in_with_google.dart';
import 'package:deskable/screens/sign_in/widgets/email_form.dart';
import 'package:flutter/material.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const String routeName = '/sign-in';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<SignInCubit>(
        create: (_) => SignInCubit(authRepository: context.read<AuthRepository>()),
        child: SignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<SignInCubit, SignInState>(
        builder: (context, state) {
          if (state.signInStatus == SignInStatus.loading)
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: (state.signInFormType != SignInFormType.initial)
                ? AppBar(
                    title: Text(context.watch<SignInCubit>().titleName()),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => context.read<SignInCubit>().changeForm(SignInFormType.initial),
                    ))
                : null,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 0),
                    child: BlocBuilder<DarkModeCubit, bool>(
                      builder: (context, state) {
                        return RichText(
                            text: TextSpan(
                          style: TextStyle(fontSize: 56),
                          children: [
                            TextSpan(
                              text: Constants.app_name_first(),
                              style: GoogleFonts.markaziText(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            TextSpan(
                              text: Constants.app_name_second(),
                              style: GoogleFonts.markaziText(color: Colors.blue[900], fontWeight: FontWeight.bold),
                            ),
                          ],
                        ));
                      },
                    ),
                  ),
                ),
                if (state.signInFormType == SignInFormType.initial) ButtonSignInWithGoogle(),
                if (state.signInFormType == SignInFormType.initial) ButtonSignInWithEmail(),
                if (state.signInFormType != SignInFormType.initial) EmailForm(contextMain: context),
              ],
            ),
          );
        },
      ),
    );
  }
}
