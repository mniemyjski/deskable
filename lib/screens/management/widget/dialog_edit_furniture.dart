import 'package:deskable/models/models.dart';
import 'package:deskable/screens/management/cubit/create_room_cubit.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogEditFurniture extends StatefulWidget {
  final Furniture furniture;

  const DialogEditFurniture({Key? key, required this.furniture}) : super(key: key);

  @override
  _DialogEditFurnitureState createState() => _DialogEditFurnitureState(furniture);
}

class _DialogEditFurnitureState extends State<DialogEditFurniture> {
  final Furniture furniture;
  final TextEditingController _controllerName = TextEditingController();
  final GlobalKey<FormState> _formKeyName = GlobalKey();

  final TextEditingController _controllerDescription = TextEditingController();
  final GlobalKey<FormState> _formKeyDescription = GlobalKey();

  _DialogEditFurnitureState(this.furniture);

  @override
  void initState() {
    _controllerDescription.text = furniture.description;
    _controllerName.text = furniture.name;
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerDescription.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: new BoxConstraints(maxWidth: 450),
            child: Form(
              key: _formKeyName,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: Languages.name(),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                ],
                textInputAction: TextInputAction.done,
                controller: _controllerName,
                // validator: (v) => Validators.password(v),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: new BoxConstraints(maxWidth: 450),
            child: Form(
              key: _formKeyDescription,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: Languages.description(),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(240),
                ],
                textInputAction: TextInputAction.done,
                controller: _controllerDescription,
                // validator: (v) => Validators.password(v),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: CustomButton(
              onPressed: () {
                context.read<CreateRoomCubit>().updateNameAndDesc(
                      furniture: furniture,
                      name: _controllerName.text,
                      description: _controllerDescription.text,
                    );

                Navigator.pop(context);
              },
              child: Text(Languages.save())),
        ),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: FaIcon(FontAwesomeIcons.arrowUp),
            onTap: () {
              context.read<CreateRoomCubit>().changeRotation(furniture, 0);
              Navigator.pop(context);
            },
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: FaIcon(FontAwesomeIcons.arrowLeft),
                onTap: () {
                  context.read<CreateRoomCubit>().changeRotation(furniture, 270);
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  child: FaIcon(FontAwesomeIcons.trash),
                  onTap: () {
                    context.read<CreateRoomCubit>().removeFurniture(furniture);
                    Navigator.pop(context);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: FaIcon(FontAwesomeIcons.arrowRight),
                onTap: () {
                  context.read<CreateRoomCubit>().changeRotation(furniture, 90);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: FaIcon(FontAwesomeIcons.arrowDown),
            onTap: () {
              context.read<CreateRoomCubit>().changeRotation(furniture, 180);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
