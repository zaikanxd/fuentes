import 'package:flutter/material.dart';
import 'package:microbank_app/components/custom_drawer.dart';
import 'package:microbank_app/models/cobranza.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/screens/cobranza/components/cobranza_page.dart';
import 'package:microbank_app/services/cobranza_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:provider/provider.dart';

class CobranzasAtrasadasScreen extends StatefulWidget {
  static const String id = 'cobranzas_atrasadas_screen';
  @override
  _CobranzasAtrasadasScreenState createState() =>
      _CobranzasAtrasadasScreenState();
}

class _CobranzasAtrasadasScreenState extends State<CobranzasAtrasadasScreen> {
  final _cobranzaService = CobranzaService.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  IconData _appBarIconData = Icons.search;
  Widget _appBarWidget;
  String _search;
  Session _session;
  String _userName;
  Future<List<Cobranza>> _fetchingCobranzas;
  @override
  void initState() {
    super.initState();
    _session = Provider.of<SessionState>(context, listen: false).session;
    _userName = Provider.of<SessionState>(context, listen: false).userName;
    _appBarWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Clientes Atrasados'),
        _userName != null
            ? Text(
                _userName,
                style: TextStyle(fontSize: 14.0),
              )
            : SizedBox(),
      ],
    );
    setCobranzas();
  }

  void setCobranzas() {
    _fetchingCobranzas = _cobranzaService.getCobranzasAtrasadas(
        session: _session,
        userName: _userName ??
            ((_session.roleId == kRolIdAdmin ||
                    _session.roleId == kRolIdGestorDeOficina)
                ? ''
                : _session.userName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        idScreeen: CobranzasAtrasadasScreen.id,
      ),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: _appBarWidget,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_appBarIconData),
            onPressed: () {
              if (_appBarIconData == Icons.search) {
                _appBarIconData = Icons.cancel;
                _appBarWidget = TextField(
                  textInputAction: TextInputAction.go,
                  onChanged: (value) {
                    if (value.length >= kMinCaracteresABuscar) {
                      setState(() => _search = value);
                    } else if (_search != null) {
                      setState(() => _search = null);
                    }
                  },
                  autofocus: FocusNode().canRequestFocus,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Buscar',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 17.0),
                );
              } else {
                _appBarIconData = Icons.search;
                _appBarWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Clientes Atrasados'),
                    _userName != null
                        ? Text(
                            _userName,
                            style: TextStyle(fontSize: 14.0),
                          )
                        : SizedBox(),
                  ],
                );
                _search = null;
              }
              setState(() {});
            },
          ),
          SizedBox(
            width: 5.0,
          )
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: CobranzaPage(
          type: TipoCobranza.pendiente,
          showHeader: false,
          soloCobranzaAtrasada: _search == null ? true : false,
          future: _search != null
              ? _cobranzaService.getCobranzasByFiltro(filtro: _search)
              : _fetchingCobranzas,
          onRefresh: () async {
            await Future.delayed(
              Duration(seconds: 2),
              () {
                setCobranzas();
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}
