import 'package:deskable/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchField extends StatefulWidget {
  final GestureTapCallback? onTapBack;
  final GestureTapCallback? onTapAdd;
  final GestureTapCallback? onTapRemove;
  final Function(String) text;

  const SearchField({Key? key, required this.onTapBack, required this.onTapAdd, required this.onTapRemove, required this.text}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: Languages.email(),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                textInputAction: TextInputAction.done,
                controller: _controller,
                onChanged: (data) => widget.text(data),
                // validator: (v) => Validators.password(v),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(onTap: widget.onTapBack, child: Icon(Icons.arrow_back)),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(onTap: widget.onTapAdd, child: Icon(Icons.add_circle)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(onTap: widget.onTapRemove, child: Icon(Icons.remove_circle)),
        ),
      ],
    );
  }
}
