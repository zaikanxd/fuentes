import 'dart:io';
import 'package:microbank_app/models/parametro.dart';
import 'package:microbank_app/services/http_service.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'dart:developer' as dev;

class UtilService {
  final parametroPath = 'parametro/obtener';
  static UtilService _instance = UtilService._privateConstructor();
  static UtilService get instance => _instance;
  UtilService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<Parametro> getFechaSistema({String id}) async {
    try {
      dynamic data =
          await _httpService.post(parametroPath, params: {'parametroID': id});
      return Parametro.fromMap(data);
    } catch (e) {
      dev.log(e.toString(), name: 'UtilService.getFechaSistema');
      throw ServiceException(e.message);
    }
  }
}
