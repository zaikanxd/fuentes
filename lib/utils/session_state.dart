import 'package:flutter/foundation.dart';
import 'package:microbank_app/models/session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microbank_app/utils/constans.dart';

class SessionState extends ChangeNotifier {
  Session _session;
  String _userName;
  final storage = new FlutterSecureStorage();


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

  Future <void> setStorage(String userName){
    storage.write(key: kStorage , value: userName);
  }
  
  Future readStorage(String key ) async {
    storage.read(key: key);
    String value = await storage.read(key: key);
    return value;
  }


  

}
