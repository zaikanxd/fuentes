import 'package:microbank_app/models/select_option.dart';
import 'package:microbank_app/services/http_service.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'dart:developer' as dev;

class SelectOptionService {
  final selectOptionPath = 'grupoDatos/listarPor';
  static SelectOptionService _instance =
      SelectOptionService._privateConstructor();
  static SelectOptionService get instance => _instance;
  SelectOptionService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<List<SelectOption>> getSelectOptions({int idGroup}) async {
    try {
      List<dynamic> data = await _httpService.post(selectOptionPath,
          params: {'pGrupoDetalleID': idGroup.toString()});
      return data.map((e) => SelectOption.fromMap(e)).toList();
    } catch (e) {
      dev.log(e.toString(), name: 'SelectOptionService.selectOptions');
      throw ServiceException(e.message);
    }
  }
}
