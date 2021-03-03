import 'package:microbank_app/models/session.dart';
import 'package:microbank_app/services/http_service.dart';
import 'package:microbank_app/utils/constans.dart';
import 'dart:developer' as dev;

import 'package:microbank_app/utils/service_exception.dart';

class AuthService {
  final loginPath = 'user/validLogin';

  static AuthService _instance = AuthService._privateConstructor();
  static AuthService get instance => _instance;
  AuthService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<Session> signIn(
      {String userName, String password, int officeId}) async {
    try {
      Map<String, dynamic> data = await _httpService.get(loginPath,
          params: Session().toMapLogin(userName, password, officeId));
      Session session = Session.fromMap(data);
      if (session.userName == null) {
        throw ServiceException('Usuario y contraseña no son correctos.');
      }
      return session;
    } on ServiceException {
      rethrow;
    } catch (e) {
      dev.log(e.toString(), name: 'AuthService.login');
      throw ServiceException(e.message ?? kMensajeErrorGenerico);
    }
  }
}
