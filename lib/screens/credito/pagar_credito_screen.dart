import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
import 'package:microbank_app/models/pago.dart';
import 'package:microbank_app/models/select_option.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/screens/credito/components/custom_radio.dart';
import 'package:microbank_app/screens/resumen/resumen_screen.dart';
import 'package:microbank_app/services/credito_service.dart';
import 'package:microbank_app/services/operacion_service.dart';
import 'package:microbank_app/services/select_option_service.dart';
import 'package:microbank_app/services/storage_service.dart';
import 'package:microbank_app/services/util_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:microbank_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:sendsms/sendsms.dart';

class PagarCreditoScreen extends StatefulWidget {
  static const String id = 'credito_screen';
  final int idCredito;
  final String nombre;
  PagarCreditoScreen({this.idCredito, this.nombre});
  @override
  _PagarCreditoScreenState createState() => _PagarCreditoScreenState();
}

class _PagarCreditoScreenState extends State<PagarCreditoScreen> {
  final _creditoService = CreditoService.instance;
  final _storageService = StorageService.instance;
  final _utilService = UtilService.instance;
  final _titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Colors.black.withOpacity(0.8),
  );
  final _subTitleStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.red);
  final _selectOptionService = SelectOptionService.instance;
  final _ratioEfectivoValue = 10;
  final _ratioTransferenciaValue = 20;

  String _dificultadValue;
  String _negocioValue;
  String _bancoValue;
  List<SelectOption> _dificultades;
  List<SelectOption> _negocios;
  List<SelectOption> _bancos;
  Future<List<SelectOption>> _fetchingBancos;
  int _groupValue;
  DateTime _voucherDate;
  File _image;
  String _nroTransaccion;
  DateTime _fechaSistema;
  Credito _credito;
  bool _isShowSpinner;
  bool _autovalidate;
  Session _session;
  bool _isExpanded;
  int __cuotaSiguiente;
  String _cuotaCancelada;
  String _cuotaActual;
  final _form = GlobalKey<FormState>();

  FocusNode _pagoCuotaFocus = FocusNode();
  TextEditingController _pagoCuotaController = TextEditingController();
  TextEditingController _moraController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Una vez que se hace unfocous del Pago Cuota
    // Se evalua el monto y el exceso se pasa a Mora
    _pagoCuotaFocus.addListener(() {
      if (!_pagoCuotaFocus.hasFocus &&
          _pagoCuotaController.text.isNotEmpty &&
          _pagoCuotaController.text.length > 0) {
        double pagoExceso =
            double.parse(_pagoCuotaController.text) - _credito.deudaTotal;
        if (pagoExceso >= 0) {
          _pagoCuotaController.text = _credito.deudaTotal.toStringAsFixed(2);
          _moraController.text = pagoExceso.toStringAsFixed(2);
        }
      }
    });
    initData();
  }

  Future<void> initData() async {
    _autovalidate = false;
    _isExpanded = false;
    _isShowSpinner = false;
    _session = Provider.of<SessionState>(context, listen: false).session;
    _groupValue = _ratioEfectivoValue;
    _fechaSistema = _fechaSistema = DateTime.parse(dateWithSlashToDate(
        (await _utilService.getFechaSistema(id: '8')).valor));
    _voucherDate = _fechaSistema;
    _credito = await _creditoService.getCredito(idCredito: widget.idCredito);
    _dificultades = await _selectOptionService.getSelectOptions(
        idGroup: SelectOption.idGroupDificultad);
    _negocios = await _selectOptionService.getSelectOptions(
        idGroup: SelectOption.idGroupNegocios);
    _fetchingBancos = _selectOptionService
        .getSelectOptions(idGroup: SelectOption.idGroupBancos)
        .then((value) => _bancos = value);

    _cuotaActual = _credito.cuotaPagada.substring(0, 2);
    __cuotaSiguiente = int.parse(_cuotaActual) + 1;
    _cuotaCancelada = _credito.cuotaPagada.substring(2, 5);
    _cuotaCancelada = __cuotaSiguiente.toString() + _cuotaCancelada.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      isShowSpinner: _isShowSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pagar Crédito'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: kBackgroundColor,
        body: Builder(
          builder: (BuildContext context) {
            return SafeArea(
              child: Form(
                key: _form,
                child: FutureBuilder<List<SelectOption>>(
                  future: _fetchingBancos,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SelectOption>> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      List<SelectOption> _bancos = snapshot.data;
                      children = <Widget>[
                        CustomCard(
                          marginTop: 20.0,
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.symmetric(horizontal: 15.0),
                            childrenPadding: EdgeInsets.zero,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    toTitleCase(widget.nombre),
                                    style: _titleStyle,
                                  ),
                                ),
                                Text(
                                  'S/ ' +
                                      _credito.cuotaDiaria.toStringAsFixed(2),
                                  style:
                                      _titleStyle.copyWith(color: Colors.red),
                                ),
                              ],
                            ),
                            trailing: CircleAvatar(
                              radius: 10.0,
                              backgroundColor: kPrimaryColor,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  _isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                            ),
                            onExpansionChanged: (value) {
                              setState(() => _isExpanded = value);
                            },
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Forma de pago'),
                                        Text(
                                          _credito.formaPago,
                                          style: _subTitleStyle,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.black54,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total a ponerse al día'),
                                        Text(
                                          'S/ ' +
                                              _credito.deudaCuotas
                                                  .toStringAsFixed(2),
                                          style: _subTitleStyle,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.black54,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Días de Atraso'),
                                        Text(
                                          _credito.diasAtraso.toString(),
                                          style: _subTitleStyle,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.black54,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Cuotas Pagada'),
                                        Text(
                                          // _cuotaCancelada,
                                          _credito.cuotaPagada,
                                          style: _subTitleStyle,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.black54,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Deuda Total'),
                                        Text(
                                          'S/ ' +
                                              _credito.deudaTotal
                                                  .toStringAsFixed(2),
                                          style: _subTitleStyle,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.black54,
                                    ),
                                    if (_credito.telefono.length > 0)
                                      GestureDetector(
                                        onTap: () =>
                                            FlutterPhoneDirectCaller.callNumber(
                                                _credito.telefono),
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                color: kPrimaryColor,
                                                size: 35,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                _credito.telefono,
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      SizedBox()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomCard(
                          marginTop: 10.0,
                          child: CustomSelect(
                            value: _dificultadValue,
                            title: 'Dificultad',
                            options: _dificultades,
                            onChanged: (SelectOption selectOption) {
                              setState(
                                  () => _dificultadValue = selectOption.valor);
                            },
                          ),
                        ),
                        CustomCard(
                          marginTop: 10.0,
                          child: CustomSelect(
                            value: _negocioValue,
                            title: '¿Abrió Negocio?',
                            options: _negocios,
                            onChanged: (SelectOption selectOption) {
                              setState(
                                  () => _negocioValue = selectOption.valor);
                            },
                          ),
                        ),
                        CustomCard(
                          marginTop: 10.0,
                          verticalPadding: 10.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pago de Cuota',
                                  style: _titleStyle,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                InnerShadowTextField(
                                  controller: _pagoCuotaController,
                                  focusNode: _pagoCuotaFocus,
                                  autovalidate: _autovalidate,
                                  validatorMessage:
                                      'Por favor ingrese la cuota',
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomCard(
                          marginTop: 10.0,
                          verticalPadding: 10.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mora',
                                  style: _titleStyle,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                InnerShadowTextField(
                                  autovalidate: _autovalidate,
                                  controller: _moraController,
                                  validatorMessage: 'Por favor ingrese la mora',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomRadio(
                                  title: 'Efectivo',
                                  value: _ratioEfectivoValue,
                                  groupValue: _groupValue,
                                  onChaged: (value) {
                                    setState(() => _groupValue = value);
                                  },
                                ),
                                CustomRadio(
                                  title: 'Transferencia',
                                  value: _ratioTransferenciaValue,
                                  groupValue: _groupValue,
                                  onChaged: (value) {
                                    setState(() => _groupValue = value);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        _groupValue == _ratioTransferenciaValue
                            ? CustomCard(
                                marginTop: 10.0,
                                child: CustomSelect(
                                  value: _bancoValue,
                                  title: 'Banco',
                                  options: _bancos,
                                  onChanged: (SelectOption selectOption) {
                                    setState(
                                        () => _bancoValue = selectOption.valor);
                                  },
                                ),
                              )
                            : SizedBox(),
                        _groupValue == _ratioTransferenciaValue
                            ? CustomCard(
                                marginTop: 10.0,
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      autovalidate: _autovalidate,
                                      text: 'N° Transacción',
                                      validatorMessage:
                                          'Por favor ingrese el N° de transacción',
                                      onChange: (value) {
                                        setState(() => _nroTransaccion = value);
                                      },
                                      icon: Icons.edit,
                                      inputType: TextInputType.number,
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Colors.black54,
                                    ),
                                    GestureDetector(
                                      child: CustomTextField(
                                        autovalidate: _autovalidate,
                                        validatorMessage:
                                            'Por favor ingrese la fecha',
                                        text: 'Fecha Voucher',
                                        enabled: false,
                                        onChange: (value) {},
                                        value: _voucherDate != null
                                            ? DateFormat('dd/MM/yyyy')
                                                .format(_voucherDate)
                                            : null,
                                        icon: Icons.widgets,
                                        inputType: TextInputType.number,
                                      ),
                                      onTap: () {
                                        showDate();
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        _groupValue == _ratioTransferenciaValue
                            ? CustomCard(
                                marginTop: 10.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 15.0),
                                      child: Text(
                                        'Foto',
                                        style: _titleStyle,
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black54,
                                      height: 1,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        padding: _image != null
                                            ? EdgeInsets.zero
                                            : EdgeInsets.only(
                                                top: 10.0, bottom: 10.0),
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: _image != null
                                            ? Image.file(
                                                _image,
                                                width: double.infinity,
                                                fit: BoxFit.fill,
                                              )
                                            : Icon(
                                                Icons.camera_alt,
                                                color: _autovalidate
                                                    ? Colors.red
                                                    : kPrimaryColor,
                                                size: 30.0,
                                              ),
                                      ),
                                      onTap: () {
                                        showDialogImagePicker(context, (file) {
                                          setState(() => _image = File(file));
                                        });
                                      },
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
                        RoundedButton(
                          color: kPrimaryColor,
                          onPressed: () async {
                            if (Platform.isAndroid) {
                              bool hasPermision = await Sendsms.hasPermission();
                              if (!hasPermision) {
                                bool response = await Sendsms.onGetPermission();
                                if (!response) {
                                  return;
                                }
                              }
                            } else if (Platform.isIOS) {
                              // NO IMPLEMENTADO
                            }

                            // Transferencia
                            if (_groupValue == _ratioTransferenciaValue) {
                              if (_form.currentState.validate() &&
                                  _image != null &&
                                  _dificultadValue != null &&
                                  _negocioValue != null &&
                                  _bancoValue != null) {
                                pagarCredito(context);
                              } else {
                                _autovalidate = true;
                                showMessage(context,
                                    'Por favor complete todo los campos, incluyendo la foto del voucher');
                              }
                            } else {
                              if (_form.currentState.validate() &&
                                  _dificultadValue != null &&
                                  _negocioValue != null) {
                                pagarCredito(context);
                              } else {
                                _autovalidate = true;
                                showMessage(context,
                                    'Por favor complete todo los campos');
                              }
                            }
                          },
                          text: 'Pagar',
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

  Future<void> showDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: _fechaSistema,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      helpText: 'Fecha de Voucher',
      locale: Locale('es'),
      selectableDayPredicate: (DateTime val) =>
          val.isBefore(_fechaSistema) || val.isAtSameMomentAs(_fechaSistema),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: kPrimaryColor,
            ),
          ),
          child: child,
        );
      },
    );
    if (date != null) {
      setState(() => _voucherDate = date);
    }
  }

  Future<void> pagarCredito(BuildContext context) async {
    String imagenUrl = '';
    try {
      setState(() => _isShowSpinner = true);
      FocusScope.of(context).unfocus();
      await Future.delayed(Duration(seconds: 2));
      if (_groupValue == _ratioTransferenciaValue) {
        imagenUrl = await _storageService.postImage(
            image: _image, typeImage: 'voucher');
      }
      await _creditoService.updateCredito(pago: getPago(imagenUrl));
      if (_credito.telefono != null && _credito.telefono.isNotEmpty) {
        String phoneNumber = _credito.telefono;
        // String socio1 = '940793099' ; //ves
        // String socio2 = ' 936953070';

        // String socio1 = '940793099' ; //olivos
        // String socio2 = '992411136' ;

        String socio1 = '952555188'; // //Piura
        String socio2 = '993341321';
        String socio3 = '943628102';

        String message = getMessage();

        if (message.length <= 160) {
          if (Platform.isAndroid) {
            await Sendsms.onSendSMS('+51' + phoneNumber, message);
            await Sendsms.onSendSMS('+51' + socio1, message);
            await Sendsms.onSendSMS('+51' + socio2, message);
            await Sendsms.onSendSMS('+51' + socio3, message);
          }
        } else {
          String primerMessage = message;
          List<String> inicioSegundoMensaje = ['Asesor', 'voucher', 'Monto'];
          int index = 0;
          int indexInicioSegundoMensaje = 0;
          while (primerMessage.length > 160) {
            indexInicioSegundoMensaje =
                primerMessage.indexOf(inicioSegundoMensaje[index]);
            index++;
            if (indexInicioSegundoMensaje < 1) {
              continue;
            }
            primerMessage =
                primerMessage.substring(0, indexInicioSegundoMensaje);
          }
          if (Platform.isAndroid) {
            await Sendsms.onSendSMS('+51' + phoneNumber, primerMessage);
            await Sendsms.onSendSMS('+51' + phoneNumber,
                message.substring(indexInicioSegundoMensaje));
            await Sendsms.onSendSMS('+51' + socio1, primerMessage);
            await Sendsms.onSendSMS(
                '+51' + socio2, message.substring(indexInicioSegundoMensaje));
            await Sendsms.onSendSMS('+51' + socio2, primerMessage);
            await Sendsms.onSendSMS(
                '+51' + socio2, message.substring(indexInicioSegundoMensaje));
            await Sendsms.onSendSMS('+51' + socio3, primerMessage);
            await Sendsms.onSendSMS('+51' + socio3,
                message.substring(indexInicioSegundoMensaje));
          }
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResumenScreen(
            message: 'Pago realizado con éxito',
          ),
        ),
      );
    } catch (e) {
      print(e);
      showMessage(
          context, (e is ServiceException) ? e.message : kMensajeErrorGenerico);
    } finally {
      setState(() => _isShowSpinner = false);
    }
  }

  String getMessage() {
    String medioPago = 'EFECTIVO';
    if (_groupValue == _ratioTransferenciaValue) {
      medioPago =
          _bancos.where((banco) => banco.valor == _bancoValue).first.nombre +
              ' voucher ' +
              _nroTransaccion +
              ', ' +
              DateFormat('dd/MM/yyyy').format(_voucherDate);
    }
    return '5 Credit:Pago Realizado ' + _cuotaCancelada + '  ' +
        DateFormat('dd/MM/yyyy HH:mm').format(new DateTime.now()) +
        ' Sr(a) ' +
        widget.nombre +
        '. Crédito nro ' +
        _credito.idCredito.toString() +
        ', Monto S/' +
        (double.parse(_pagoCuotaController.text) +
                double.parse(_moraController.text))
            .toStringAsFixed(2) +
        // ' Cuota Pagada:' +
        // _cuotaCancelada.toString() +
        ' en ' +
        medioPago +
        ', Asesor: ' +
        _session.description;
  }

  Pago getPago(String imagenUrl) {
    return Pago(
        idCredito: widget.idCredito,
        idUser: _session.userName,
        idOficinaOpe: _session.officeId,
        tipo: 1,
        monto: double.parse(_pagoCuotaController.text),
        mora: double.parse(_moraController.text),
        codOperacion: _groupValue,
        fecha: DateFormat('yyyy-MM-dd').format(_fechaSistema),
        fechaVoucher: DateFormat('yyyy-MM-dd').format(_voucherDate),
        idKardexHijo: 0,
        idBanco: _bancoValue ?? '',
        idOpcion1: _dificultadValue ?? '',
        idOpcion2: _negocioValue ?? '',
        valuta: 0,
        numCheque: _nroTransaccion ?? '',
        imagen: imagenUrl);
  }
}
