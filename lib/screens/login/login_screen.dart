import 'package:flutter/material.dart';
import 'package:microbank_app/components/custom_card.dart';
import 'package:microbank_app/components/custom_select.dart';
import 'package:microbank_app/components/loading_page.dart';
import 'package:microbank_app/components/rounded_button.dart';
import 'package:microbank_app/components/custom_text_field.dart';
import 'package:microbank_app/models/oficina.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/screens/login/components/custom_drop_down_button.dart';
import 'package:microbank_app/screens/resumen/resumen_screen.dart';
import 'package:microbank_app/services/auth_service.dart';
import 'package:microbank_app/services/office_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService.instance;
  final _officeService = OfficeService.instance;
  final _session = SessionState();

  String userName;
  String password;
  int officeId;
  bool isLoading = false;
  List<Oficina> oficinas = List();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
      super.initState();

    final valueStorage = _session.readStorage(kStorage);

    if (valueStorage != null) {
      Navigator.pushReplacementNamed(context, ResumenScreen.id);
    }
     else {
      super.initState();
    }

    AlertDialog(
      title: Text("el usuario es:"+_session.readStorage(kStorage).toString()),
    );

    if (valueStorage != null) {
      AlertDialog(
        title: Text(_session.readStorage(kStorage).toString()),
      );
    } else {
      AlertDialog(
        title: Text("no hay sesion"),
      );
    }

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setOffices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      isShowSpinner: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      kLoginLogoImagePath,
                      height: 180,
                    ),
                    Text(
                      'Bienvenido a microbank',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21.0,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Ingrese para continuar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 15.0,
                      ),
                    ),
                    CustomCard(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            CustomTextField(
                              autovalidate: false,
                              text: 'Usuario',
                              onChange: (value) {
                                setState(() => userName = value);
                              },
                              icon: Icons.person,
                              focusNode: _focusNode,
                            ),
                            Divider(
                              height: 5.0,
                              color: Colors.black,
                            ),
                            (userName == null || oficinas.length < 2)
                                ? SizedBox()
                                : CustomDropDownButton(
                                    onChanged: (value) {
                                      setState(() => officeId = value);
                                    },
                                    oficinas: oficinas,
                                  ),
                            (userName == null || oficinas.length < 2)
                                ? SizedBox()
                                : Divider(
                                    height: 5.0,
                                    color: Colors.black,
                                  ),
                            CustomTextField(
                              text: 'Contraseña',
                              autovalidate: false,
                              onChange: (value) {
                                setState(() => password = value);
                              },
                              icon: Icons.lock,
                              obscureText: true,
                              passwordFunction: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    RoundedButton(
                      color: kAccentColor,
                      text: 'Ingresar',
                      onPressed: () {
                        signIn(context);
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> setOffices() async {
    oficinas = await _officeService.getOficinas(userName: userName);
    setState(() {});
  }

  Future<void> signIn(BuildContext context) async {
    // WORKAROUND para evitar que el analista seleccionado quede "quedado"
    Provider.of<SessionState>(context, listen: false).setUserName(null);
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);
    try {
      await Future.delayed(Duration(seconds: 3), () {});
      Session session = await _authService.signIn(
          userName: userName,
          password: password,
          officeId: oficinas.length < 2 ? oficinas.first.id : officeId);
      Provider.of<SessionState>(context, listen: false).setSession(session);
      //Llamar a la funcion Storage
      Provider.of<SessionState>(context, listen: false).setStorage(userName);

      Navigator.pushReplacementNamed(context, ResumenScreen.id);
    } catch (e) {
      String message =
          (e is ServiceException) ? e.message : kMensajeErrorGenerico;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: kDuracionSegundosSnackBar),
      ));
    } finally {
      setState(() => isLoading = false);
    }
  }
}
