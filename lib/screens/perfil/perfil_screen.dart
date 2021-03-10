import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:microbank_app/components/custom_card.dart';
import 'package:microbank_app/components/custom_drawer.dart';
import 'package:microbank_app/components/rounded_button.dart';
import 'package:microbank_app/models/analista.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/screens/login/login_screen.dart';
import 'package:microbank_app/screens/perfil/components/custom_analista_select.dart';
import 'package:microbank_app/services/analista_service.dart';
import 'package:microbank_app/services/util_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:microbank_app/utils/utils.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatefulWidget {
  static const String id = 'perfil_screen';
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _utilService = UtilService.instance;
  final _analistaService = AnalistaService.instance;
  final _vsession = SessionState();
  Session _session;
  String _userName;
  DateTime _fechaSistema;
  Future<List<Analista>> _fetchingAnalistas;
  String _analistaValue;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    _session = Provider.of<SessionState>(context, listen: false).session;
    _userName = Provider.of<SessionState>(context, listen: false).userName;
    _fechaSistema = DateTime.parse(dateWithSlashToDate(
        (await _utilService.getFechaSistema(id: '8')).valor));
    _fetchingAnalistas =
        _analistaService.getAnalistas(idOficina: _session.officeId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mi Perfil'),
            _userName != null
                ? Text(
                    _userName,
                    style: TextStyle(fontSize: 14.0),
                  )
                : SizedBox(),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer(
        idScreeen: PerfilScreen.id,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Analista>>(
          future: _fetchingAnalistas,
          builder:
              (BuildContext context, AsyncSnapshot<List<Analista>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              List<Analista> _analistas = [];
              _analistas.add(
                  Analista(name: 'TODOS', userName: 'TODOS', value: 'TODOS'));
              _analistas.addAll(snapshot.data);
              _analistaValue = _analistas
                  .where(
                      (analista) => analista.userName == (_userName ?? 'TODOS'))
                  .first
                  .name;

              children = <Widget>[
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: kPrimaryColor,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                      Text(
                        toTitleCase(_session.description),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        toTitleCase(_session.officeName) +
                            ' | ' +
                            DateFormat('dd/MM/yyyy').format(_fechaSistema),
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        toTitleCase(_session.roleName),
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      _session.roleId == kRolIdAdmin ||
                              _session.roleId == kRolIdGestorDeOficina
                          ? CustomCard(
                              marginTop: 10.0,
                              child: CustomAnalistaSelect(
                                value: _analistaValue,
                                title: 'Analista',
                                options: _analistas,
                                onChanged: (Analista analista) {
                                  if (analista.userName == 'TODOS') {
                                    _analistaValue = 'TODOS';
                                    _userName = null;
                                  } else {
                                    _userName = analista.userName;
                                    _analistaValue = analista.name;
                                  }
                                  Provider.of<SessionState>(context,
                                          listen: false)
                                      .setUserName(analista.userName == 'TODOS'
                                          ? null
                                          : analista.userName);
                                  setState(() {});
                                },
                              ),
                            )
                          : SizedBox(),
                      Container(
                        width: 250,
                        child: RoundedButton(
                          color: kAccentColor,
                          text: 'Cerrar Sesión',
                          onPressed: () {
                            showCustomDialog(
                              context,
                              Text(
                                  'Si desea continuar tendrá que volver a iniciar sesión'),
                              () async {
                                await Provider.of<SessionState>(context,
                                        listen: false)
                                    .setUserName(null);
                                _vsession.deleteStorage();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, LoginScreen.id, (route) => false);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(
                  Icons.error,
                  size: 35.0,
                  color: Colors.red,
                ),
                Text(
                  'Ooopps!',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Ocurrío un error. Intentelo nuevamente',
                  style: TextStyle(color: Colors.black54),
                )
              ];
            } else {
              children = <Widget>[
                SpinKitCircle(
                  size: 30.0,
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                      ),
                    );
                  },
                ),
              ];
            }
            return snapshot.hasData
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    ),
                  )
                : Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
