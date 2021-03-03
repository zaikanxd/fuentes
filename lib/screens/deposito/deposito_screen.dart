import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:microbank_app/components/custom_card.dart';
import 'package:microbank_app/components/custom_drawer.dart';
import 'package:microbank_app/models/deposito.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/screens/deposito/components/deposito_item.dart';
import 'package:microbank_app/screens/deposito/nuevo_deposito_screen.dart';
import 'package:microbank_app/services/deposito_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:microbank_app/utils/utils.dart';
import 'package:provider/provider.dart';

class DepositoScreen extends StatefulWidget {
  static const String id = 'deposito_screen';
  final String message;
  DepositoScreen({this.message});
  @override
  _DepositoScreenState createState() => _DepositoScreenState();
}

class _DepositoScreenState extends State<DepositoScreen> {
  final _depositoService = DepositoService.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Session _session;
  String _userName;
  Future<List<Deposito>> _fetchingDepositos;
  bool _showSnackBar = false;
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() {
    _session = Provider.of<SessionState>(context, listen: false).session;
    _userName = Provider.of<SessionState>(context, listen: false).userName;

    setDepositos();
  }

  void setDepositos() {
    _fetchingDepositos = _depositoService.getDepositos(
        session: _session,
        userName: _userName ??
            ((_session.roleId == kRolIdAdmin ||
                    _session.roleId == kRolIdGestorDeOficina)
                ? ''
                : _session.userName));
    _fetchingDepositos.whenComplete(() => _showSnackBar = true);
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
            Text('Depósitos'),
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
        idScreeen: DepositoScreen.id,
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, NuevoDepositoScreen.id);
            },
            child: Icon(Icons.add),
            backgroundColor: kPrimaryColor,
          );
        },
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: kAccentColor,
        displacement: 25.0,
        strokeWidth: 3.0,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2), () {
            setDepositos();
            setState(() {});
          });
        },
        child: SafeArea(
          child: FutureBuilder<List<Deposito>>(
            future: _fetchingDepositos,
            builder:
                (BuildContext context, AsyncSnapshot<List<Deposito>> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                List<Deposito> _depositos = snapshot.data;
                children = <Widget>[
                  CustomCard(
                    marginTop: 10.0,
                    verticalPadding: 15.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'S/ ' +
                                double.parse(_depositos
                                        .map((e) => double.parse(e.importe))
                                        .toList()
                                        .fold(0,
                                            (value, element) => value + element)
                                        .toString())
                                    .toStringAsFixed(2),
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  _depositos.length > 0
                      ? Expanded(
                          child: CustomCard(
                            marginTop: 20.0,
                            child: ListView.builder(
                              itemCount: _depositos.length,
                              itemBuilder: (BuildContext context, int index) {
                                return DepositoItem(
                                  deposito: _depositos[index],
                                );
                              },
                            ),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 30.0,
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
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
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
              if (_showSnackBar && widget.message != null) {
                Future.delayed(Duration(milliseconds: 500), () {
                  showMessage(context, widget.message);
                  _showSnackBar = false;
                });
              }
              return snapshot.hasData
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
