import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String userName;
  AppBarTitle({this.userName});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cobranzas'),
        userName != null
            ? Text(
                userName,
                style: TextStyle(fontSize: 14.0),
              )
            : SizedBox(),
      ],
    );
  }
}
