import 'package:flutter/material.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/styles.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool obscureText;
  final TextInputType inputType;
  final Function onChange;
  final bool passwordFunction;
  final FocusNode focusNode;
  final bool enabled;
  final String value;
  final String validatorMessage;
  final bool autovalidate;
  CustomTextField(
      {this.icon,
      this.text,
      this.onChange,
      this.obscureText = false,
      this.inputType,
      this.passwordFunction = false,
      this.focusNode,
      this.enabled = true,
      this.value,
      this.validatorMessage,
      this.autovalidate});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscure;
  @override
  void initState() {
    obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: TextFormField(
        focusNode: widget.focusNode,
        textAlign: TextAlign.justify,
        keyboardType: widget.inputType ?? TextInputType.text,
        obscureText: obscure,
        enabled: widget.enabled,
        validator: (value) {
          if (value.isEmpty) {
            return widget.validatorMessage;
          }
        },
        autovalidate: widget.autovalidate,
        decoration: kTextFieldDecoration.copyWith(
          errorStyle: TextStyle(fontSize: 11),
          prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: kPrimaryColor,
                )
              : null,
          labelText: widget.text,
          suffixIcon: widget.passwordFunction
              ? GestureDetector(
                  child: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: kPrimaryColor,
                  ),
                  onTap: () {
                    setState(() => obscure = !obscure);
                  },
                )
              : SizedBox(),
        ),
        controller: widget.value != null
            ? TextEditingController(text: widget.value)
            : null,
        onChanged: (value) => widget.onChange(value),
      ),
    );
  }
}

class InnerShadowTextField extends StatelessWidget {
  final TextEditingController controller;
  final String validatorMessage;
  final bool autovalidate;
  final FocusNode focusNode;

  InnerShadowTextField({
    this.controller,
    this.validatorMessage,
    this.autovalidate,
    this.focusNode,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBackgroundColor,
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return validatorMessage;
          }
        },
        focusNode: focusNode,
        controller: controller,
        autovalidate: autovalidate,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          isDense: true,
          prefixText: 'S/ ',
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        ),
      ),
    );
  }
}
