import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/languages.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({Key? key}) : super(key: key);

  static const String routeName = '/create-company';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => CreateCompanyScreen(),
    );
  }

  @override
  _CreateCompanyScreenState createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final GlobalKey<FormState> _formKeyName = GlobalKey();
  final GlobalKey<FormState> _formKeyDescription = GlobalKey();

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // Company company = Company.create(name: _controllerName.text, description: _controllerDescription.text);
                // context.read<CompanyCubit>().create(company);
              },
              icon: Icon(Icons.save)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
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
            // Padding(
            //   padding: const EdgeInsets.only(top: 32),
            //   child: CustomButton(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(Languages.create()),
            //         ],
            //       ),
            //       onPressed: () {
            //         Company company = Company.create(name: _controllerName.text, description: _controllerDescription.text);
            //         context.read<CompanyCubit>().create(company);
            //       }),
            // ),
          ],
        ),
      ),
    );
  }
}
