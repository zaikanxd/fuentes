import 'package:microbank_app/models/operacion.dart';
import 'package:microbank_app/services/http_service.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'dart:developer' as dev;

class OperacionService {
  final operacionPath = 'pago/obtenerOperacionxCodigo';
  final extornoPath = 'extorno/extornarOperacion';

  static OperacionService _instance = OperacionService._privateConstructor();
  static OperacionService get instance => _instance;
  OperacionService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<Operacion> getOperacion({int idKardex}) async {
    try {
      dynamic data = await _httpService.post(operacionPath,
          params: Operacion(idKardex: idKardex).toMapGet());
      dev.log('data $data', name: 'OperacionService.getOperacion');
      return Operacion.fromMap(data);
    } catch (e) {
      dev.log(e.toString(), name: 'OperacionService.getOperacion');
      throw ServiceException(e.message);
    }
  }

  Future<void> extornarOperacion({Operacion operacion}) async {
    try {
      await _httpService.put(extornoPath, params: operacion.toMapExtornar());
    } catch (e) {
      dev.log(e.toString(), name: 'OperacionService.extornarOperacion');
      throw ServiceException(e.message);
    }
  }
}
