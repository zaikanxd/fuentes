import 'package:flutter/material.dart';
import 'package:microbank_app/utils/constans.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double marginTop;
  final double verticalPadding;
  CustomCard({this.child, this.marginTop, this.verticalPadding});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
          left: kHorizontalMarginSize,
          right: kHorizontalMarginSize,
          top: marginTop ?? 50.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 0.0),
        child: child,
      ),
    );
  }
}
