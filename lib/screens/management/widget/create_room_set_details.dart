import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/screens/management/cubit/create_room_cubit.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/custom_button.dart';
import 'package:deskable/widgets/custom_selector_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRoomSetDetails extends StatefulWidget {
  const CreateRoomSetDetails({Key? key}) : super(key: key);

  @override
  State<CreateRoomSetDetails> createState() => _CreateRoomSetDetailsState();
}

class _CreateRoomSetDetailsState extends State<CreateRoomSetDetails> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();
  final GlobalKey<FormState> _formKeyName = GlobalKey();
  final GlobalKey<FormState> _formKeyDesc = GlobalKey();

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerDesc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _buildNameForm(),
            _buildDescForm(),
            _buildOpenCloseSelector(),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          width: double.infinity,
          child: BlocBuilder<CreateRoomCubit, CreateRoomState>(
            builder: (context, state) {
              return CustomButton(
                onPressed: () {
                  Room room = Room(
                    x: state.x,
                    y: state.y,
                    open: state.open,
                    close: state.close,
                    furniture: state.furniture,
                    name: _controllerName.text,
                    description: _controllerDesc.text,
                  );

                  context.read<CreateRoomCubit>().create(room);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(Languages.create()),
              );
            },
          ),
        )
      ],
    );
  }

  Container _buildOpenCloseSelector() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: BlocBuilder<CreateRoomCubit, CreateRoomState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(Languages.open()),
                  CustomSelectorData(
                    onPressed: null,
                    widget: Text(state.open.toString()),
                    onPressedBack: () => context.read<CreateRoomCubit>().decreaseOpen(),
                    onPressedForward: () => context.read<CreateRoomCubit>().increaseOpen(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(Languages.close()),
                  CustomSelectorData(
                    onPressed: null,
                    widget: Text(state.close.toString()),
                    onPressedBack: () => context.read<CreateRoomCubit>().decreaseClose(),
                    onPressedForward: () => context.read<CreateRoomCubit>().increaseClose(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Padding _buildDescForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: new BoxConstraints(maxWidth: 450),
        child: Form(
          key: _formKeyDesc,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: Languages.description(),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(300),
            ],
            textInputAction: TextInputAction.next,
            controller: _controllerDesc,
            // validator: (v) => Validators.password(v),
          ),
        ),
      ),
    );
  }

  Padding _buildNameForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: new BoxConstraints(maxWidth: 450),
        child: Form(
          key: _formKeyName,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: Languages.room_name(),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(25),
            ],
            textInputAction: TextInputAction.next,
            controller: _controllerName,
            // validator: (v) => Validators.password(v),
          ),
        ),
      ),
    );
  }
}
