import 'package:microbank_app/models/oficina.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/services/http_service.dart';
import 'dart:developer' as dev;

import 'package:microbank_app/utils/service_exception.dart';

class OfficeService {
  final officePath = 'Office/listarPorUsuario';

  static OfficeService _instance = OfficeService._privateConstructor();
  static OfficeService get instance => _instance;
  OfficeService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<List<Oficina>> getOficinas({String userName}) async {
    try {
      List<dynamic> data = await _httpService.get(officePath,
          params: Session().toMapSecond(userName));
      return data.map((e) => Oficina.fromMap(e)).toList();
    } catch (e) {
      dev.log(e.toString(), name: 'OfficeService.oficinas');
      throw ServiceException(e.message);
    }
  }
}
