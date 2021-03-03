import 'package:flutter/material.dart';
import 'package:microbank_app/screens/login/login_screen.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:progress_indicators/progress_indicators.dart';

class InitScreen extends StatefulWidget {
  static const String id = 'init_screen';
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: kSegundosEspera),
      () {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: GlowingProgressIndicator(
          child: Image.asset(
            kLogoImagePath,
            width: 240,
          ),
        ),
      ),
    );
  }
}
