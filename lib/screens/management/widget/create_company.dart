import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCompany extends StatefulWidget {
  final Company? company;
  const CreateCompany({Key? key, this.company}) : super(key: key);

  @override
  State<CreateCompany> createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final GlobalKey<FormState> _formKeyName = GlobalKey();
  final GlobalKey<FormState> _formKeyDescription = GlobalKey();

  @override
  void initState() {
    if (widget.company != null) {
      _controllerName.text = widget.company!.name;
      _controllerDescription.text = widget.company!.description;
    }
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNameForm(),
            _buildDescForm(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: CustomButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.company == null ? Languages.create() : Languages.save()),
                ],
              ),
              onPressed: () => _onTap(context, widget.company)),
        ),
      ],
    );
  }

  Padding _buildDescForm() {
    return Padding(
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
              labelText: Languages.company_name(),
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

  void _onTap(BuildContext context, Company? company) {
    if (company != null) {
      context.read<CompanyCubit>().update(company.copyWith(name: _controllerName.text, description: _controllerDescription.text));
    } else {
      Company _company = Company.create(name: _controllerName.text, description: _controllerDescription.text);
      context.read<CompanyCubit>().create(_company);
    }
    Navigator.pop(context);
  }
}
