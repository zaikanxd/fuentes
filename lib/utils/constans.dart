import 'package:flutter/material.dart';

const kEntorno = 'prod'; // test o prod

const kPrimaryColor = Color(0xFF00A132);
const kPrimaryColorDark = Color(0xFF007100);
const kPrimaryColorLight = Color(0xFF54D361);
const kAccentColor = Color(0xFFF8E500);
const kBackgroundColor = Color(0xFFF2F4F8);

const kSegundosEspera = 5;
const kDuracionSegundosSnackBar = 3;
const kBorderRadiusButton = 10.0;
const kFontSizeButton = 16.5;
const kHorizontalMarginSize = 20.0;

const kAplicacionId = 1;
const port = (kEntorno == 'prod') ? '8080' : '8040';
const kBaseUrlService = '200.1.177.214:$port';
const kComplementMovilUrl = '/DevitCreditosMovil/v1/';
const kComplementUrl = '/itBankSeguridadApi/webapiz2h/v1/';
const kComplementStorageUrl = '/itBankFileUploadApi/webapiz2h/v1/fileupload/';
const kApiURL = '200.1.177.214:$port/itBankSeguridadApi/webapiz2h/v1/';
const kLogoImagePath = 'images/logo.png';
const kLoginLogoImagePath = 'images/login_logo.png';
const kMensajeErrorGenerico = 'Se presentó un problema';

const kMinCaracteresABuscar = 4;
const kRolIdAdmin = 1;
const kRolIdGestorDeOficina = 1014;
