import 'package:microbank_app/models/resumen.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/services/http_service.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'dart:developer' as dev;

class ResumenService {
  final resumenPath = 'resumen/listarResumen';

  static ResumenService _instance = ResumenService._privateConstructor();
  static ResumenService get instance => _instance;
  ResumenService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<Resumen> getResumen({Session session, String userName}) async {
    try {
      List<dynamic> data = await _httpService.post(resumenPath,
          params: session.toMapThird(userName));
      return Resumen.fromListMap(data);
    } catch (e) {
      dev.log(e.toString(), name: 'ResumenService.resumen');
      throw ServiceException(e.message);
    }
  }
}
