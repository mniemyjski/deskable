import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController controller,
    required String labelText,
    FormFieldValidator<String>? validator,
    IconData? icon,
    bool obscureText = false,
  })  : _formKey = formKey,
        _controller = controller,
        _obscureText = obscureText,
        _labelText = labelText,
        _icon = icon,
        _validator = validator,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _controller;
  final FormFieldValidator<String>? _validator;
  final bool _obscureText;
  final String _labelText;
  final IconData? _icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 200, maxWidth: 450),
        child: Form(
          key: _formKey,
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: _labelText,
              labelStyle: TextStyle(color: Colors.white),
              contentPadding: EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Colors.white38,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              icon: _icon != null
                  ? FaIcon(
                      _icon,
                      size: 40,
                      color: Colors.white,
                    )
                  : null,
            ),
            textInputAction: TextInputAction.done,
            obscureText: _obscureText,
            controller: _controller,
            validator: _validator,
          ),
        ),
      ),
    );
  }
}
