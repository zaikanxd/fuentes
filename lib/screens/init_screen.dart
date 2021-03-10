import 'package:flutter/material.dart';
import 'package:microbank_app/screens/login/login_screen.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../utils/session_state.dart';

class InitScreen extends StatefulWidget {
  static const String id = 'init_screen';
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final _session = SessionState();
  
  @override
  void initState(){
    super.initState();
    Future.delayed(
      Duration(seconds: kSegundosEspera),
      () {
        _session.readStorage(context, kStorage);
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
