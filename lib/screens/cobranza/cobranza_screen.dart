import 'package:flutter/material.dart';
import 'package:microbank_app/components/custom_drawer.dart';
import 'package:microbank_app/models/cobranza.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/screens/cobranza/components/app_bar_title.dart';
import 'package:microbank_app/screens/cobranza/components/cobranza_page.dart';
import 'package:microbank_app/screens/cobranza/components/search_text_field.dart';
import 'package:microbank_app/services/cobranza_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:microbank_app/utils/utils.dart';
import 'package:provider/provider.dart';

class CobranzaScreen extends StatefulWidget {
  static const String id = 'cobranza_screen';
  final int indexTab;
  final String message;
  CobranzaScreen({this.indexTab, this.message});
  @override
  _CobranzaScreenState createState() => _CobranzaScreenState();
}

class _CobranzaScreenState extends State<CobranzaScreen> {
  final _cobranzaService = CobranzaService.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Session _session;
  String _userName;
  IconData _appBarIconData = Icons.search;
  Widget _appBarWidget;
  String _search;
  int _indexTab;
  bool _showSnackBar = false;
  Future<List<Cobranza>> _fetchingCobranzasRealizadas;
  Future<List<Cobranza>> _fetchingCobranzasPendientes;
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    _indexTab = widget.indexTab ?? 0;
    _session = Provider.of<SessionState>(context, listen: false).session;
    _userName = Provider.of<SessionState>(context, listen: false).userName;
    _appBarWidget = AppBarTitle(userName: _userName);
    setCobranzasPendientes();
    setCobranzasRealizadas();
  }

  void setCobranzasPendientes() {
    _fetchingCobranzasPendientes = _cobranzaService.getCobranzasPendientes(
        session: _session,
        userName: _userName ??
            ((_session.roleId == kRolIdAdmin ||
                    _session.roleId == kRolIdGestorDeOficina)
                ? ''
                : _session.userName));
  }

  void setCobranzasRealizadas() {
    _fetchingCobranzasRealizadas = _cobranzaService.getCobranzasRealizadas(
        session: _session,
        userName: _userName ??
            ((_session.roleId == kRolIdAdmin ||
                    _session.roleId == kRolIdGestorDeOficina)
                ? ''
                : _session.userName));
    _fetchingCobranzasRealizadas.whenComplete(() {
      _showSnackBar = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _indexTab,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(
          idScreeen: CobranzaScreen.id,
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
            _indexTab != 1
                ? IconButton(
                    icon: Icon(_appBarIconData),
                    onPressed: () {
                      if (_appBarIconData == Icons.search) {
                        _appBarIconData = Icons.cancel;
                        _appBarWidget = SearchTextField(
                          onChanged: (value) {
                            _search = value;
                            setState(() {});
                          },
                          search: _search,
                        );
                      } else {
                        _appBarIconData = Icons.search;
                        _appBarWidget = AppBarTitle(userName: _userName);
                        _search = null;
                      }
                      setState(() {});
                    },
                  )
                : SizedBox(),
          ],
          bottom: TabBar(
            indicator: BoxDecoration(
              color: kPrimaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 0.5,
                  offset: Offset(1, -2), // changes position of shadow
                ),
              ],
              border: Border(
                bottom: BorderSide(color: kAccentColor, width: 2),
              ),
            ),
            tabs: [
              Tab(
                text: 'Pendiente',
              ),
              Tab(
                text: 'Realizada',
              )
            ],
            indicatorColor: kPrimaryColor,
            onTap: (index) {
              _indexTab = index;
              if (index == 1) {
                _appBarWidget = AppBarTitle(userName: _userName);
              } else if (_search != null && index == 0) {
                _appBarWidget = SearchTextField(
                  onChanged: (value) {
                    _search = value;
                    setState(() {});
                  },
                  search: _search,
                );
              }
              setState(() {});
            },
          ),
        ),
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              if (_showSnackBar && widget.message != null) {
                Future.delayed(Duration(milliseconds: 500), () {
                  showMessage(context, widget.message);
                  _showSnackBar = false;
                });
              }
              return TabBarView(
                children: [
                  CobranzaPage(
                    type: TipoCobranza.pendiente,
                    future: _search != null
                        ? _cobranzaService.getCobranzasByFiltro(filtro: _search)
                        : _fetchingCobranzasPendientes,
                    soloCobranzaAtrasada: _search == null ? true : false,
                    onRefresh: () async {
                      await Future.delayed(
                        Duration(seconds: 2),
                        () {
                          setCobranzasPendientes();
                          setState(() {});
                        },
                      );
                    },
                  ),
                  CobranzaPage(
                    type: TipoCobranza.realizada,
                    future: _fetchingCobranzasRealizadas,
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 2), () {
                        setCobranzasRealizadas();
                        setState(() {});
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
