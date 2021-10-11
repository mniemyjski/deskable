import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/account_repository.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:deskable/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef AccountToVoidFunc = void Function(Account);
typedef ListAccountToVoidFunc = void Function(List<Account>);

class SearchDialog extends StatefulWidget {
  final List<Account> alreadyAccountAdded;
  final AccountToVoidFunc onTapAdd;
  final ListAccountToVoidFunc onTapMany;
  final AccountToVoidFunc onTapRemove;

  const SearchDialog({
    Key? key,
    required this.alreadyAccountAdded,
    required this.onTapAdd,
    required this.onTapMany,
    required this.onTapRemove,
  }) : super(key: key);

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool search = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchAccountCubit(
        accountRepository: context.read<AccountRepository>(),
      ),
      child: BlocBuilder<SearchAccountCubit, SearchAccountState>(
        builder: (context, state) {
          return search ? _buildSearch(context, state) : _buildAddMany(context);
        },
      ),
    );
  }

  Column _buildAddMany(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => search = !search),
              icon: Icon(Icons.arrow_back_ios),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(Strings.add_many_email(),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: TextFormField(
              minLines: 15,
              maxLines: 15,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                hintText: Strings.add_many_email_sample(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              textInputAction: TextInputAction.done,
              controller: _controller,
            ),
          ),
        ),
        Container(
            width: double.infinity,
            child: CustomButton(
                onPressed: () async {
                  String txt = _controller.text.replaceAll(RegExp(r' '), '');
                  List<String> result = txt.split(';');

                  List<Account> accounts = await context
                      .read<SearchAccountCubit>()
                      .searchManyEmail(result);
                  widget.onTapMany(accounts);
                },
                child: Text(Strings.add())))
      ],
    );
  }

  Column _buildSearch(BuildContext context, SearchAccountState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                // isCollapsed: true,
                contentPadding: EdgeInsets.all(8),
                hintText: Strings.search(),
                icon: FaIcon(
                  Icons.search,
                  color: Colors.black87,
                ),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              textInputAction: TextInputAction.done,
              controller: _controller,
              onChanged: (String search) {
                if (search.length > 2)
                  context.read<SearchAccountCubit>().search(search);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() {
                _controller.clear();
                search = !search;
              }),
              child: Text(Strings.add_many()),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(8.9),
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: state.accounts.length,
                itemBuilder: (BuildContext _, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.accounts[index].name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(state.accounts[index].email,
                              style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                      Row(
                        children: [
                          if (!widget.alreadyAccountAdded
                              .contains(state.accounts[index]))
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () =>
                                    widget.onTapAdd(state.accounts[index]),
                                child: Icon(Icons.add_circle),
                              ),
                            ),
                          if (widget.alreadyAccountAdded
                              .contains(state.accounts[index]))
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () =>
                                    widget.onTapRemove(state.accounts[index]),
                                child: Icon(Icons.remove_circle),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
        )
      ],
    );
  }
}
