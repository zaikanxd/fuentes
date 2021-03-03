import 'package:microbank_app/models/credito.dart';
import 'package:microbank_app/models/pago.dart';
import 'package:microbank_app/services/http_service.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'dart:developer' as dev;

class CreditoService {
  final postCreditoPath = 'pago/insertarPago';
  final getCreditoPath = 'credito/otenerCreditoxCodigo';

  static CreditoService _instance = CreditoService._privateConstructor();
  static CreditoService get instance => _instance;
  CreditoService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<void> updateCredito({Pago pago}) async {
    try {
      await _httpService.put(postCreditoPath, params: pago.toMap());
    } catch (e) {
      dev.log(e.toString(), name: 'CreditoService.updateCredito');
      throw ServiceException(e.message);
    }
  }

  Future<Credito> getCredito({int idCredito}) async {
    try {
      dynamic data = await _httpService.post(getCreditoPath,
          params: Credito(idCredito: idCredito).toMapGet());
      dev.log('data $data', name: 'CreditoService.getCredito');

      return Credito.fromMap(data);
    } catch (e) {
      dev.log(e.toString(), name: 'CreditoService.getCredito');
      throw ServiceException(e.message);
    }
  }
}
