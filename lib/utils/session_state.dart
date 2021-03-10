import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:microbank_app/models/session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:provider/provider.dart';

import '../models/session.dart';
import '../screens/login/login_screen.dart';
import '../screens/resumen/resumen_screen.dart';

class SessionState extends ChangeNotifier {
  final _storage = new FlutterSecureStorage();
  Session _session;
  String _userName;
  String _storageValue;

  Session get session => _session;
  String get userName => _userName;
  String get storageValue => _storageValue;

  Future<void> setSession(Session session) {
    _session = session;
    notifyListeners();
  }

  Future<void> setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  Future<void> setStorage(Session session) async {
    await _storage.write(key: kStorage, value: jsonEncode(session.toMapFour()));
    notifyListeners();
  }

  Future<void> readStorage(BuildContext context, String key) async {
    _storageValue = await _storage.read(key: key);
    if (_storageValue != null && _storageValue.isNotEmpty) {
      _session = Session.fromMapStorage(jsonDecode(_storageValue));
      Provider.of<SessionState>(context, listen: false).setSession(_session);
      notifyListeners();
      await Navigator.pushReplacementNamed(context, ResumenScreen.id);
    } else
      await Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  Future<void> deleteStorage() async {
    await _storage.deleteAll();
  }
}
