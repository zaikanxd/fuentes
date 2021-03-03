import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:microbank_app/components/custom_card.dart';
import 'package:microbank_app/components/custom_select.dart';
import 'package:microbank_app/components/custom_text_field.dart';
import 'package:microbank_app/components/loading_page.dart';
import 'package:microbank_app/components/rounded_button.dart';
import 'package:microbank_app/models/deposito.dart';
import 'package:microbank_app/models/select_option.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/screens/deposito/deposito_screen.dart';
import 'package:microbank_app/services/deposito_service.dart';
import 'package:microbank_app/services/select_option_service.dart';
import 'package:microbank_app/services/storage_service.dart';
import 'package:microbank_app/services/util_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'package:microbank_app/utils/session_state.dart';
import 'package:microbank_app/utils/utils.dart';
import 'package:provider/provider.dart';

class NuevoDepositoScreen extends StatefulWidget {
  static const String id = 'nuevo_deposito_screen';
  @override
  _NuevoDepositoScreenState createState() => _NuevoDepositoScreenState();
}

class _NuevoDepositoScreenState extends State<NuevoDepositoScreen> {
  final _selectOptionsService = SelectOptionService.instance;
  final _utilService = UtilService.instance;
  final _depositoService = DepositoService.instance;
  final _storageService = StorageService.instance;
  final _form = GlobalKey<FormState>();
  final _titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Colors.black.withOpacity(0.8),
  );
  Future<List<SelectOption>> _fetchingBancos;
  Session _session;
  bool _isShowSpinner;
  bool _autovalidate;
  DateTime _fechaProceso;
  DateTime _fechaSistema;
  String _bancoValue;
  DateTime _voucherDate;
  String _nroOperacion;
  File _image;
  TextEditingController _montoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    _isShowSpinner = false;
    _autovalidate = false;
    _fechaSistema = DateTime.parse(dateWithSlashToDate(
        (await _utilService.getFechaSistema(id: '8')).valor));
    _fechaProceso = _fechaSistema;
    _voucherDate = _fechaSistema;
    _session = Provider.of<SessionState>(context, listen: false).session;
    _fetchingBancos = _selectOptionsService.getSelectOptions(
        idGroup: SelectOption.idGroupBancos);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      isShowSpinner: _isShowSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nuevo Depósito'),
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
                  future: _fetchingBancos,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SelectOption>> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      List<SelectOption> _bancos = snapshot.data;
                      children = <Widget>[
                        CustomCard(
                          marginTop: 10.0,
                          child: GestureDetector(
                            child: CustomTextField(
                              autovalidate: _autovalidate,
                              validatorMessage: 'Por favor ingrese la fecha',
                              text: 'Fecha Proceso',
                              enabled: false,
                              onChange: (value) {},
                              value: _fechaProceso != null
                                  ? DateFormat('dd/MM/yyyy')
                                      .format(_fechaProceso)
                                  : null,
                              icon: Icons.widgets,
                            ),
                            onTap: () async {
                              DateTime _dateTime =
                                  await showDate('Fecha de Proceso', true);
                              if (_dateTime != null) {
                                setState(() => _fechaProceso = _dateTime);
                              }
                            },
                          ),
                        ),
                        CustomCard(
                          marginTop: 10.0,
                          child: CustomSelect(
                            value: _bancoValue,
                            title: 'Banco',
                            options: _bancos,
                            onChanged: (SelectOption selectOption) {
                              setState(() => _bancoValue = selectOption.valor);
                            },
                          ),
                        ),
                        CustomCard(
                          marginTop: 10.0,
                          child: Column(
                            children: [
                              CustomTextField(
                                autovalidate: _autovalidate,
                                text: 'N° Operación',
                                validatorMessage:
                                    'Por favor ingrese el N° de Operación',
                                onChange: (value) {
                                  setState(() => _nroOperacion = value);
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
                                ),
                                onTap: () async {
                                  DateTime _dateTime =
                                      await showDate('Fecha de Voucher', false);
                                  if (_dateTime != null) {
                                    setState(() => _voucherDate = _dateTime);
                                  }
                                },
                              ),
                            ],
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
                                  'Monto',
                                  style: _titleStyle,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                InnerShadowTextField(
                                  autovalidate: _autovalidate,
                                  controller: _montoController,
                                  validatorMessage:
                                      'Por favor ingrese el Monto',
                                )
                              ],
                            ),
                          ),
                        ),
                        CustomCard(
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
                        ),
                        RoundedButton(
                          color: kPrimaryColor,
                          onPressed: () {
                            if (_form.currentState.validate() &&
                                _image != null &&
                                _bancoValue != null) {
                              nuevoDeposito(context);
                            } else {
                              setState(() => _autovalidate = true);
                              showMessage(context,
                                  'Por favor complete todos los campos');
                            }
                          },
                          text: 'Guardar',
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

  Future<DateTime> showDate(String helperText, bool isFechaProceso) async {
    return await showDatePicker(
      context: context,
      initialDate: _fechaSistema,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      helpText: helperText,
      locale: Locale('es'),
      selectableDayPredicate: (DateTime val) =>
          (val.isBefore(_fechaSistema) &&
              (isFechaProceso
                  ? val.isAfter(_fechaSistema.subtract(Duration(days: 3)))
                  : true)) ||
          val.isAtSameMomentAs(_fechaSistema),
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
  }

  Future<void> nuevoDeposito(BuildContext context) async {
    String imageUrl;
    try {
      setState(() => _isShowSpinner = true);
      FocusScope.of(context).unfocus();
      imageUrl =
          await _storageService.postImage(image: _image, typeImage: 'voucher');
      Deposito deposito = getDeposito(imageUrl);
      await _depositoService.createDeposito(deposito: deposito);
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DepositoScreen(
              message: 'Deposito registrado con éxito',
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

  Deposito getDeposito(String imageUrl) {
    return Deposito(
      fechaVoucher: DateFormat('yyyy-MM-dd').format(_voucherDate),
      fecha: DateFormat('yyyy-MM-dd').format(_fechaProceso),
      nroOperacion: _nroOperacion,
      idUsuReg: _session.userName,
      idBanco: _bancoValue,
      idOficina: _session.officeId.toString(),
      imageUrl: imageUrl ?? '',
      importe: _montoController.text,
    );
  }
}
