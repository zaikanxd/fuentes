import 'package:microbank_app/models/analista.dart';
import 'package:microbank_app/services/http_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'dart:developer' as dev;

class AnalistaService {
  final analistasPath = 'analista/listarValue';

  static AnalistaService _instance = AnalistaService._privateConstructor();
  static AnalistaService get instance => _instance;
  AnalistaService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<List<Analista>> getAnalistas({int idOficina}) async {
    try {
      List<dynamic> data = await _httpService.post(analistasPath,
          params: Analista(idOficina: idOficina).toMapGet());
      return data.map((e) => Analista.fromMap(e)).toList();
    } catch (e) {
      dev.log(e.toString(), name: 'AnalistaService.getAnalistas');
      throw ServiceException(e.message ?? kMensajeErrorGenerico);
    }
  }
}
