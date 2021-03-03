import 'package:flutter/material.dart';
import 'package:microbank_app/utils/constans.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final Color fontColor;
  final bool hasBorder;
  final String text;
  final Function onPressed;

  RoundedButton(
      {this.color,
      this.fontColor,
      this.hasBorder = false,
      this.text,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kHorizontalMarginSize, vertical: 30.0),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 13.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusButton),
          side:
              BorderSide(color: hasBorder ? Colors.black : Colors.transparent),
        ),
        onPressed: onPressed,
        color: color ?? kPrimaryColor,
        child: Text(
          text,
          style: TextStyle(
            color: fontColor,
            fontWeight: FontWeight.w600,
            fontSize: kFontSizeButton,
          ),
        ),
      ),
    );
  }
}
