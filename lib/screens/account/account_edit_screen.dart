import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/cubit/upload_to_storage/update_avatar_cubit.dart';
import 'package:deskable/screens/screens.dart';
import 'package:deskable/utilities/strings.dart';
import 'package:deskable/utilities/validators.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AccountEditScreen extends StatefulWidget {
  const AccountEditScreen({Key? key}) : super(key: key);
  static const String routeName = '/account-edit';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => AccountEditScreen(),
    );
  }

  @override
  _AccountEditScreenState createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final GlobalKey<FormState> _formKeyName = GlobalKey();

  @override
  void initState() {
    _controllerName.text = context.read<AccountCubit>().state.account!.name;
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.edit_profile()),
          actions: [
            IconButton(
              onPressed: () =>
                  _save(context: context, name: _controllerName.text),
              icon: Icon(Icons.save),
            ),
          ],
        ),
        body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => _changeImage(context),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: BlocBuilder<AccountCubit, AccountState>(
                        builder: (context, state) {
                          if (state.status == EAccountStatus.created)
                            return CustomAvatar(url: state.account!.photoUrl);
                          return CustomAvatar();
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: Form(
                      key: _formKeyName,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: Strings.name(),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white38,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.done,
                        controller: _controllerName,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        validator: (v) => Validators.name(v),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _changeImage(BuildContext context) async {
    final picker = ImagePicker();
    final result = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 1080,
      maxHeight: 1920,
    );

    if (result != null) {
      Uint8List uint8List = await result.readAsBytes();
      var image = await Navigator.pushNamed(
        context,
        CropImageScreen.routeName,
        arguments: CropScreenArguments(uint8List: uint8List, isCircleUi: true),
      );
      if (image != null) {
        context.read<UpdateAvatarCubit>().update(image as Uint8List);
      }
    }
  }

  _save({required BuildContext context, required String name}) async {
    final loading = BotToast.showLoading();
    final name = context.read<AccountCubit>().state.account!.name;

    if (name == _controllerName.text) Navigator.pop(context);

    if (_formKeyName.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      bool updated = await context.read<AccountCubit>().updateName(name);

      if (updated) {
        Navigator.pop(context);
      } else {
        customFlashBar(Strings.name_not_available());
        _controllerName.text = context.read<AccountCubit>().state.account!.name;
      }
    }
    loading.call();
  }
}
