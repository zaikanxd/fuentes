import 'package:flutter/material.dart';
import 'package:microbank_app/utils/constans.dart';

class SearchTextField extends StatelessWidget {
  final Function onChanged;
  final String search;
  SearchTextField({this.onChanged, this.search});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: search),
      textInputAction: TextInputAction.go,
      autofocus: FocusNode().canRequestFocus,
      onChanged: (value) {
        if (value.length >= kMinCaracteresABuscar) {
          onChanged(value);
          //setState(() => _search = value);
        } else if (search != null) {
          onChanged(null);
          // setState(() => _search = null);
        }
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Buscar',
        hintStyle: TextStyle(
          color: Colors.white,
          decoration: TextDecoration.none,
        ),
      ),
      style: TextStyle(color: Colors.white, fontSize: 17.0),
    );
  }
}
