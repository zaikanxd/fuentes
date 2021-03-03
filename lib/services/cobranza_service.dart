import 'package:microbank_app/models/cobranza.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/services/http_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'dart:developer' as dev;

import 'package:microbank_app/utils/service_exception.dart';

class CobranzaService {
  final pagosPendientesPath = 'cliente/listarClientesPendientesPago';
  final pagosRealizadosPath = 'cliente/listarClientesPagados';
  final clientesAtrasadosPath = 'cliente/listarClientesAtrasados';
  final clientesByFilterPath = 'persona/listarPersonasxCriterio';

  static CobranzaService _instance = CobranzaService._privateConstructor();
  static CobranzaService get instance => _instance;
  CobranzaService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<List<Cobranza>> getCobranzasPendientes(
      {Session session, String userName}) async {
    try {
      List<dynamic> data = await _httpService.post(pagosPendientesPath,
          params: session.toMapFirst(userName));
      return data.map((e) => Cobranza.fromMap(e)).toList();
    } catch (e) {
      dev.log(e.toString(), name: 'ClienteService.cobranzasPendientes');
      throw ServiceException(e.message ?? kMensajeErrorGenerico);
    }
  }

  Future<List<Cobranza>> getCobranzasRealizadas(
      {Session session, String userName}) async {
    try {
      List<dynamic> data = await _httpService.post(pagosRealizadosPath,
          params: session.toMapFirst(userName));
      return data.map((e) => Cobranza.fromMap(e)).toList();
    } catch (e) {
      dev.log(e.toString(), name: 'ClienteService.cobranzasRealizadas');
      throw ServiceException(e.message ?? kMensajeErrorGenerico);
    }
  }

  Future<List<Cobranza>> getCobranzasAtrasadas(
      {Session session, String userName}) async {
    try {
      List<dynamic> data = await _httpService.post(clientesAtrasadosPath,
          params: session.toMapFirst(userName));
      return data.map((e) => Cobranza.fromMap(e)).toList();
    } catch (e) {
      dev.log(e.toString(), name: 'ClienteService.cobranzasAtrasadas');
      throw ServiceException(e.message ?? kMensajeErrorGenerico);
    }
  }

  Future<List<Cobranza>> getCobranzasByFiltro({String filtro}) async {
    try {
      List<dynamic> data = await _httpService
          .post(clientesByFilterPath, params: {'cCriterio': filtro});
      return data.map((e) => Cobranza.fromMap(e)).toList();
    } catch (e) {
      dev.log(e.toString(), name: 'ClienteService.getCobranzasByFiltro');
      throw ServiceException(e.message ?? kMensajeErrorGenerico);
    }
  }
}
