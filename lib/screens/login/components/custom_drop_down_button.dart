import 'package:flutter/material.dart';
import 'package:microbank_app/models/oficina.dart';
import 'package:microbank_app/utils/constans.dart';

class CustomDropDownButton extends StatelessWidget {
  final Function onChanged;
  final List<Oficina> oficinas;
  CustomDropDownButton({this.onChanged, this.oficinas});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: DropdownButtonFormField<int>(
        onChanged: (value) => onChanged(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: 'Oficina',
          prefixIcon: Icon(
            Icons.location_city,
            color: kPrimaryColor,
          ),
          labelStyle: TextStyle(color: kPrimaryColor),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        items: oficinas
            .map((e) => e.id)
            .toList()
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              oficinas.where((oficina) => oficina.id == value).first?.name,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}
