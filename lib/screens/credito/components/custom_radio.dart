import 'package:flutter/material.dart';
import 'package:microbank_app/utils/constans.dart';

class CustomRadio extends StatelessWidget {
  final Function onChaged;
  final int value;
  final String title;
  final int groupValue;
  CustomRadio({this.onChaged, this.value, this.title, this.groupValue});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 185,
      padding: EdgeInsets.zero,
      child: RadioListTile(
        activeColor: kPrimaryColor,
        onChanged: (value) => onChaged(value),
        value: value,
        groupValue: groupValue,
        dense: true,
        title: Text(
          title,
          maxLines: 1,
          style: TextStyle(fontSize: 14.5, color: Colors.black),
        ),
      ),
    );
  }
}
