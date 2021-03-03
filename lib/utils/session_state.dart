import 'package:flutter/foundation.dart';
import 'package:microbank_app/models/session.dart';

class SessionState extends ChangeNotifier {
  Session _session;
  String _userName;

  Session get session => _session;

  String get userName => _userName;

  Future<void> setSession(Session session) {
    _session = session;
    notifyListeners();
  }

  Future<void> setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }
}
