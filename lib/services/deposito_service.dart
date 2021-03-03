import 'package:microbank_app/models/deposito.dart';
import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/services/http_service.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'dart:developer' as dev;

class DepositoService {
  final getAlldepositoPath = 'deposito/listarDepositos';
  final registrarDepositoPath = 'deposito/registrarDeposito';
  final getDepositoPath = 'deposito/obtener';
  final extornarPath = 'extorno/extornarDeposito';

  static DepositoService _instance = DepositoService._privateConstructor();
  static DepositoService get instance => _instance;
  DepositoService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<List<Deposito>> getDepositos(
      {Session session, String userName}) async {
    try {
      List<dynamic> data = await _httpService.post(getAlldepositoPath,
          params: session.toMapFirst(userName));
      return data.map((e) => Deposito.fromMap(e)).toList();
    } catch (e) {
      dev.log(e.toString(), name: 'DepositoService.getAll');
      throw ServiceException(e.message);
    }
  }

  Future<void> createDeposito({Deposito deposito}) async {
    try {
      await _httpService.put(registrarDepositoPath,
          params: deposito.toMapCreate());
    } catch (e) {
      dev.log(e.toString(), name: 'DepositoService.createDeposito');
      throw ServiceException(e.message);
    }
  }

  Future<Deposito> getDeposito({int idKardex}) async {
    try {
      dynamic data = await _httpService.post(getDepositoPath,
          params: Deposito(idKardex: idKardex).toMapGet());
      dev.log('data $data', name: 'DepositoService.get');
      return Deposito.fromMap(data);
    } catch (e) {
      dev.log(e.toString(), name: 'DepositoService.get');
      throw ServiceException(e.message);
    }
  }

  Future<void> extornarDeposito({Deposito deposito}) async {
    try {
      await _httpService.put(extornarPath, params: deposito.toMapExtorno());
    } catch (e) {
      dev.log(e.toString(), name: 'DepositoService.extornarDeposito');
      throw ServiceException(e.message);
    }
  }
}
