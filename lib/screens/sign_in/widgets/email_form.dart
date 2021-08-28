import 'package:deskable/models/models.dart';
import 'package:deskable/screens/sign_in/cubit/sign_in_cubit.dart';
import 'package:deskable/utilities/validators.dart';
import 'package:deskable/widgets/custom_flash_bar.dart';
import 'package:flutter/material.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailForm extends StatefulWidget {
  final BuildContext contextMain;
  const EmailForm({Key? key, required this.contextMain}) : super(key: key);

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final GlobalKey<FormState> _formKeyEmail = GlobalKey();
  final GlobalKey<FormState> _formKeyPassword = GlobalKey();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        _controllerEmail.text = state.email;
        _controllerPassword.text = state.password;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKeyEmail,
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: FaIcon(
                          Icons.mail,
                          color: Colors.grey,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      controller: _controllerEmail,
                      validator: (v) => Validators.email(v),
                    ),
                  ),
                ),
                if (state.signInFormType != SignInFormType.reset)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKeyPassword,
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: FaIcon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        controller: _controllerPassword,
                        validator: (v) => Validators.password(v),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: CustomButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FaIcon(
                            Icons.mail,
                            size: 40,
                            color: Colors.white,
                          ),
                          Text(context.watch<SignInCubit>().buttonName()),
                          Container(),
                        ],
                      ),
                      onPressed: () => onPressedSignInOrRegister(state)),
                ),
                if (state.signInFormType != SignInFormType.reset)
                  TextButton(
                      onPressed: () {
                        context.read<SignInCubit>().changeForm(SignInFormType.reset);
                      },
                      child: Text(Languages.forgot_your_password())),
                if (state.signInFormType != SignInFormType.reset)
                  TextButton(
                      onPressed: () => onPressedChangeTypeForm(state),
                      child: Text(
                        state.signInFormType == SignInFormType.signIn ? Languages.need_register() : Languages.have_account_sign_in(),
                      )),
              ],
            ),
          ),
        );
      },
    );
  }

  void onPressedChangeTypeForm(SignInState state) {
    if (state.signInFormType == SignInFormType.signIn) {
      context.read<SignInCubit>().changeForm(SignInFormType.register);
    } else {
      context.read<SignInCubit>().changeForm(SignInFormType.signIn);
    }
  }

  void onPressedSignInOrRegister(SignInState state) async {
    Failure? failure;
    if (state.signInFormType == SignInFormType.reset && _formKeyEmail.currentState!.validate()) {
      context.read<SignInCubit>().valueForm(email: _controllerEmail.text);
      failure = await context.read<SignInCubit>().signInWithEmail();
      if (failure == null) customFlashBar(widget.contextMain, Languages.reset_mail());
    }

    if (state.signInFormType != SignInFormType.reset && _formKeyEmail.currentState!.validate() && _formKeyPassword.currentState!.validate()) {
      context.read<SignInCubit>().valueForm(email: _controllerEmail.text, password: _controllerPassword.text);
      failure = await context.read<SignInCubit>().signInWithEmail();
    }
    if (failure != null) customFlashBar(widget.contextMain, failure.message);
  }
}
