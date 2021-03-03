import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:microbank_app/components/custom_card.dart';
import 'package:microbank_app/components/custom_drawer.dart';
import 'package:microbank_app/models/resumen.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/services/resumen_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:microbank_app/utils/utils.dart';
import 'package:provider/provider.dart';

class ResumenScreen extends StatefulWidget {
  static const String id = 'resumen_screen';
  final String message;
  ResumenScreen({this.message});

  @override
  _ResumenScreenState createState() => _ResumenScreenState();
}

class _ResumenScreenState extends State<ResumenScreen> {
  final _resumenService = ResumenService.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextStyle _titleStyle =
      TextStyle(fontWeight: FontWeight.w700, fontSize: 17.0);
  TextStyle _title2Style = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.blueAccent);

  TextStyle _valueStyle = TextStyle(fontWeight: FontWeight.bold);
  Session _session;
  String _userName;
  Future<Resumen> fetchingResumen;
  bool _showSnackBar = false;
  @override
  void initState() {
    super.initState();
    _session = Provider.of<SessionState>(context, listen: false).session;
    _userName = Provider.of<SessionState>(context, listen: false).userName;
    initData();
  }

  void initData() {
    fetchingResumen = _resumenService.getResumen(
        session: _session,
        userName: _userName ??
            ((_session.roleId == kRolIdAdmin ||
                    _session.roleId == kRolIdGestorDeOficina)
                ? ''
                : _session.userName));
    fetchingResumen.whenComplete(() => _showSnackBar = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        idScreeen: ResumenScreen.id,
      ),
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen'),
            _userName != null
                ? Text(
                    _userName,
                    style: TextStyle(fontSize: 13),
                  )
                : SizedBox(),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: kAccentColor,
        displacement: 25.0,
        strokeWidth: 3.0,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2), () {
            initData();
            setState(() {});
          });
        },
        child: SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return FutureBuilder<Resumen>(
                future: fetchingResumen,
                builder:
                    (BuildContext context, AsyncSnapshot<Resumen> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    Resumen resumen = snapshot.data;
                    children = <Widget>[
                      CustomCard(
                        marginTop: 20.0,
                        verticalPadding: 15.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Clientes',
                                style: _titleStyle,
                              ),
                            ),
                            Divider(
                              color: Colors.black54,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Clientes asignados'),
                                      Text(
                                        resumen.clientesAsignados,
                                        style: _valueStyle,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Clientes con pago semanal'),
                                      Text(
                                        resumen.clientesConPagoSemanal,
                                        style: _valueStyle,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Clientes con pago diario'),
                                      Text(
                                        resumen.clientesConPagoDiario,
                                        style: _valueStyle,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomCard(
                        marginTop: 10.0,
                        verticalPadding: 15.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Estado de la cartera',
                                style: _titleStyle,
                              ),
                            ),
                            Divider(
                              color: Colors.black54,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Clientes al día'),
                                      Text(
                                        resumen.clientesAlDia,
                                        style: _valueStyle,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Clientes con 1 cuota por pagar'),
                                      Text(
                                        resumen.clientesConUnaCuotaPorPagar,
                                        style: _valueStyle,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Clientes con 2 cuota por pagar'),
                                      Text(
                                        resumen.clientesConDosCuotasPorPagar,
                                        style: _valueStyle,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Clientes con 3 cuota por pagar'),
                                      Text(
                                        resumen.clientesConTresCuotasPorPagar,
                                        style: _valueStyle,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomCard(
                        marginTop: 10.0,
                        verticalPadding: 15.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Estado de la cartera',
                                style: _titleStyle,
                              ),
                            ),
                            Divider(
                              color: Colors.black54,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Clientes que pagaron hoy'),
                                  Text(
                                    resumen.clientesQuePagaronHoy,
                                    style: _valueStyle,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kHorizontalMarginSize),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cuadre Diario',
                              style: _titleStyle,
                            ),
                            Divider(
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                      CustomCard(
                        marginTop: 10.0,
                        verticalPadding: 15.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Dif. entre lo cobrado y depositado',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                'S/ ' +
                                    resumen.diferenciaEntreCobradoYDepositado,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      CustomCard(
                        marginTop: 10.0,
                        verticalPadding: 15.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Depósito bancos por cobro del día',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                'S/ ' + resumen.depositoEnBancoPorCobroDelDia,
                                style: _valueStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                      CustomCard(
                        marginTop: 10.0,
                        verticalPadding: 15.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total en efectivo',
                                    style: _title2Style,
                                  ),
                                  Text(
                                    'S/ ' +
                                        (double.parse(resumen.pagoEnEfectivo) +
                                                double.parse(resumen
                                                    .pagoDeMorosidadEnEfectivo))
                                            .toStringAsFixed(2),
                                    style: _title2Style,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black54,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Cobros'),
                                      Text(
                                        'S/ ' + resumen.pagoEnEfectivo,
                                        style: _valueStyle,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Cobros de morosidad'),
                                      Text(
                                        'S/ ' +
                                            resumen.pagoDeMorosidadEnEfectivo,
                                        style: _valueStyle,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomCard(
                        marginTop: 10.0,
                        verticalPadding: 15.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Total transferencia al banco',
                                      style: _title2Style,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text(
                                    'S/ ' +
                                        (double.parse(resumen
                                                    .pagosViaTransferenciaEnBanco) +
                                                double.parse(resumen
                                                    .pagosDeMorosidadViaTransferencia))
                                            .toStringAsFixed(2),
                                    style: _title2Style,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black54,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Pagos'),
                                      Text(
                                        'S/ ' +
                                            resumen
                                                .pagosViaTransferenciaEnBanco,
                                        style: _valueStyle,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Pagos de morosidad'),
                                      Text(
                                        'S/ ' +
                                            resumen
                                                .pagosDeMorosidadViaTransferencia,
                                        style: _valueStyle,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomCard(
                        marginTop: 10.0,
                        verticalPadding: 15.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Total cobrado en el día',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                'S/ ' + resumen.pagoTotalesIncluyendoMora,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      )
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
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20.0),
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
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
