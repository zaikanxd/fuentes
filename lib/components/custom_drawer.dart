import 'package:flutter/material.dart';
import 'package:microbank_app/screens/cobranza/cobranza_screen.dart';
import 'package:microbank_app/screens/cobranza/cobranzas_atrasadas_screen.dart';
import 'package:microbank_app/screens/deposito/deposito_screen.dart';
import 'package:microbank_app/screens/login/login_screen.dart';
import 'package:microbank_app/screens/perfil/perfil_screen.dart';
import 'package:microbank_app/screens/resumen/resumen_screen.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:microbank_app/utils/utils.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final String idScreeen;
  CustomDrawer({this.idScreeen});
  final _titleStyle = TextStyle(fontSize: 17.0);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final session = Provider.of<SessionState>(context, listen: false).session;
    return SafeArea(
      child: Container(
        color: Colors.white,
        width: size.width * 0.9,
        child: Column(
          children: [
            Container(
              alignment: Alignment(0.0, 0.0),
              color: kPrimaryColor,
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    toTitleCase(session.description),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        idScreeen == ResumenScreen.id
                            ? Navigator.pop(context)
                            : Navigator.pushReplacementNamed(
                                context, ResumenScreen.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Resumen',
                            style: _titleStyle,
                          ),
                          Icon(
                            Icons.leaderboard,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.8,
                    color: kPrimaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        idScreeen == CobranzaScreen.id
                            ? Navigator.pop(context)
                            : Navigator.pushReplacementNamed(
                                context, CobranzaScreen.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cobranza',
                            style: _titleStyle,
                          ),
                          Icon(
                            Icons.attach_money,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.8,
                    color: kPrimaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        idScreeen == CobranzasAtrasadasScreen.id
                            ? Navigator.pop(context)
                            : Navigator.pushReplacementNamed(
                                context, CobranzasAtrasadasScreen.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Clientes Atrasados',
                            style: _titleStyle,
                          ),
                          Icon(
                            Icons.flag,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.8,
                    color: kPrimaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        idScreeen == DepositoScreen.id
                            ? Navigator.pop(context)
                            : Navigator.pushReplacementNamed(
                                context, DepositoScreen.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Depósitos',
                            style: _titleStyle,
                          ),
                          Icon(
                            Icons.payment,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.8,
                    color: kPrimaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        idScreeen == PerfilScreen.id
                            ? Navigator.pop(context)
                            : Navigator.pushReplacementNamed(
                                context, PerfilScreen.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mi Perfil',
                            style: _titleStyle,
                          ),
                          Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.8,
                    color: kPrimaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        showCustomDialog(
                            context,
                            Text(
                                'Si desea continuar tendrá que volver a iniciar sesión'),
                            () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginScreen.id, (route) => false);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cerrar Sesión',
                            style: _titleStyle,
                          ),
                          Icon(
                            Icons.payment,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.8,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
