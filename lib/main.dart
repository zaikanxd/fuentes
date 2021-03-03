import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:microbank_app/screens/cobranza/cobranza_screen.dart';
import 'package:microbank_app/screens/cobranza/cobranzas_atrasadas_screen.dart';
import 'package:microbank_app/screens/credito/extornar_credito_screen.dart';
import 'package:microbank_app/screens/credito/pagar_credito_screen.dart';
import 'package:microbank_app/screens/deposito/deposito_screen.dart';
import 'package:microbank_app/screens/deposito/nuevo_deposito_screen.dart';
import 'package:microbank_app/screens/init_screen.dart';
import 'package:microbank_app/screens/login/login_screen.dart';
import 'package:microbank_app/screens/perfil/perfil_screen.dart';
import 'package:microbank_app/screens/resumen/resumen_screen.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SessionState(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('es'),
          Locale('en'),
        ],
        title: 'MicroBank',
        theme: ThemeData.light().copyWith(
          primaryColor: kPrimaryColor,
          primaryColorDark: kPrimaryColorDark,
          primaryColorLight: kPrimaryColorLight,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: kPrimaryColor,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: InitScreen.id,
        routes: {
          InitScreen.id: (context) => InitScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          ResumenScreen.id: (context) => ResumenScreen(),
          CobranzaScreen.id: (context) => CobranzaScreen(),
          CobranzasAtrasadasScreen.id: (context) => CobranzasAtrasadasScreen(),
          PagarCreditoScreen.id: (context) => PagarCreditoScreen(),
          ExtornarCreditoScreen.id: (context) => ExtornarCreditoScreen(),
          DepositoScreen.id: (context) => DepositoScreen(),
          NuevoDepositoScreen.id: (context) => NuevoDepositoScreen(),
          PerfilScreen.id: (context) => PerfilScreen(),
        },
      ),
    );
  }
}
