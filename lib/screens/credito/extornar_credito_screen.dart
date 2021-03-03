import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:microbank_app/components/custom_card.dart';
import 'package:microbank_app/components/custom_select.dart';
import 'package:microbank_app/components/custom_text_field.dart';
import 'package:microbank_app/components/loading_page.dart';
import 'package:microbank_app/components/rounded_button.dart';
import 'package:microbank_app/models/credito.dart';
import 'package:microbank_app/models/operacion.dart';
import 'package:microbank_app/models/select_option.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/screens/cobranza/cobranza_screen.dart';
import 'package:microbank_app/services/credito_service.dart';
import 'package:microbank_app/services/operacion_service.dart';
import 'package:microbank_app/services/select_option_service.dart';
import 'package:microbank_app/services/storage_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:microbank_app/utils/utils.dart';
import 'package:provider/provider.dart';

class ExtornarCreditoScreen extends StatefulWidget {
  static const String id = 'extornar_credito_screen';
  final String nombre;
  final int idKardex;
  final int idCredito;
  ExtornarCreditoScreen({this.nombre, this.idKardex, this.idCredito});
  @override
  _ExtornarCreditoScreenState createState() => _ExtornarCreditoScreenState();
}

class _ExtornarCreditoScreenState extends State<ExtornarCreditoScreen> {
  final _selectOptionsService = SelectOptionService.instance;
  final _operacionService = OperacionService.instance;
  final _creditoService = CreditoService.instance;
  final _storageService = StorageService.instance;
  final _form = GlobalKey<FormState>();
  Future<List<SelectOption>> _fetchingMotivos;
  bool _autovalidate;
  bool _isShowSpinner;
  String _motivoValue;
  String _comentario;
  Operacion _operacion;
  Credito _credito;
  Session _session;
  Uint8List _imageBytes;
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    _isShowSpinner = false;
    _autovalidate = false;
    _session = Provider.of<SessionState>(context, listen: false).session;
    _operacion =
        await _operacionService.getOperacion(idKardex: widget.idKardex);
    _credito = await _creditoService.getCredito(idCredito: widget.idCredito);
    _imageBytes =
        await _storageService.getImage(imagePath: _operacion.rutaImagen);
    _fetchingMotivos = _selectOptionsService.getSelectOptions(
        idGroup: SelectOption.idGroupMotivosExtorno);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      isShowSpinner: _isShowSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Extornar Pago'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return SafeArea(
              child: Form(
                key: _form,
                child: FutureBuilder<List<SelectOption>>(
                  future: _fetchingMotivos,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SelectOption>> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      List<SelectOption> _motivos = snapshot.data;
                      children = <Widget>[
                        CustomCard(
                          marginTop: 10.0,
                          verticalPadding: 15.0,
                          child: Column(
                            children: [
                              Text(
                                toTitleCase(widget.nombre),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              if (_credito.telefono.length > 0)
                                GestureDetector(
                                  onTap: () =>
                                      FlutterPhoneDirectCaller.callNumber(
                                          _credito.telefono),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 25.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.call,
                                          color: kPrimaryColor,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          _credito?.telefono ?? '-',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                SizedBox(),
                            ],
                          ),
                        ),
                        CustomCard(
                          marginTop: 10.0,
                          verticalPadding: 10.0,
                          child: Column(
                            children: [
                              Container(
                                height: 30,
                                padding: EdgeInsets.all(5.0),
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    VerticalDivider(
                                      color: kPrimaryColor,
                                      thickness: 1.5,
                                    ),
                                    Expanded(
                                      child: Text('Monto'),
                                    ),
                                    Text(
                                      'S/ ' +
                                              _operacion?.monto
                                                  .toStringAsFixed(2) ??
                                          '-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                padding: EdgeInsets.all(5.0),
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    VerticalDivider(
                                      color: kPrimaryColor,
                                      thickness: 1.5,
                                    ),
                                    Expanded(
                                      child: Text('Fecha'),
                                    ),
                                    Text(
                                      _operacion?.fecha != null
                                          ? DateFormat('dd/MM/yyyy', 'es')
                                              .format(DateTime.parse(
                                                  _operacion.fecha))
                                          : '-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                padding: EdgeInsets.all(5.0),
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    VerticalDivider(
                                      color: kPrimaryColor,
                                      thickness: 1.5,
                                    ),
                                    Expanded(
                                      child: Text('Usuario'),
                                    ),
                                    Text(
                                      _operacion?.usuario ?? '-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                padding: EdgeInsets.all(5.0),
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    VerticalDivider(
                                      color: kPrimaryColor,
                                      thickness: 1.5,
                                    ),
                                    Expanded(
                                      child: Text('Modo'),
                                    ),
                                    Text(
                                      toTitleCase(
                                          _operacion.operacion.toLowerCase() ==
                                                  'Pago Efectivo'.toLowerCase()
                                              ? 'Efectivo'
                                              : 'Transferencia'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              _operacion.operacion.toLowerCase() ==
                                      'Pago Efectivo'.toLowerCase()
                                  ? SizedBox()
                                  : Container(
                                      height: 30,
                                      padding: EdgeInsets.all(5.0),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          VerticalDivider(
                                            color: kPrimaryColor,
                                            thickness: 1.5,
                                          ),
                                          Expanded(
                                            child: Text('N° Transacción'),
                                          ),
                                          Text(
                                            _operacion?.numCheque,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                              Container(
                                height: 30,
                                padding: EdgeInsets.all(5.0),
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    VerticalDivider(
                                      color: kPrimaryColor,
                                      thickness: 1.5,
                                    ),
                                    Expanded(
                                      child: Text('Oficina'),
                                    ),
                                    Text(
                                      _operacion.oficina == ""
                                          ? '-'
                                          : toTitleCase(_operacion.oficina),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        _operacion.rutaImagen.isNotEmpty
                            ? CustomCard(
                                marginTop: 10.0,
                                verticalPadding: 20.0,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Foto',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialogImage(
                                                context, _imageBytes);
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 60.0,
                                            backgroundImage:
                                                MemoryImage(_imageBytes),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        CustomCard(
                          marginTop: 10.0,
                          child: CustomSelect(
                            value: _motivoValue,
                            title: 'Motivo',
                            options: _motivos,
                            onChanged: (SelectOption selectOption) {
                              setState(() => _motivoValue = selectOption.valor);
                            },
                          ),
                        ),
                        CustomCard(
                          marginTop: 10.0,
                          child: CustomTextField(
                            autovalidate: _autovalidate,
                            text: 'Comentario',
                            validatorMessage: 'Por favor ingrese un comentario',
                            onChange: (value) {
                              setState(() => _comentario = value);
                            },
                            icon: Icons.comment,
                            inputType: TextInputType.text,
                          ),
                        ),
                        RoundedButton(
                          color: kPrimaryColor,
                          onPressed: () {
                            if (_form.currentState.validate()) {
                              extornarPago(context);
                            } else {
                              setState(() => _autovalidate = true);
                              showMessage(context,
                                  'Por favor complete todos los campos');
                            }
                          },
                          text: 'Extornar',
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
          },
        ),
      ),
    );
  }

  Future<void> extornarPago(BuildContext context) async {
    try {
      setState(() => _isShowSpinner = true);
      FocusScope.of(context).unfocus();
      await Future.delayed(Duration(seconds: 2));
      await _operacionService.extornarOperacion(
          operacion: Operacion(
              idKardex: widget.idKardex,
              motivo: _motivoValue,
              comentario: _comentario,
              idUser: _session.userName));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CobranzaScreen(
              indexTab: 0,
              message: 'Extorno realizado con éxito',
            ),
          ),
          (route) => false);
    } catch (e) {
      showMessage(
          context, (e is ServiceException) ? e.message : kMensajeErrorGenerico);
    } finally {
      setState(() => _isShowSpinner = false);
    }
  }
}
