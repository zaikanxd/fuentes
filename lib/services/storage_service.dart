import 'dart:io';
import 'dart:typed_data';
import 'package:microbank_app/services/http_service.dart';
import 'package:microbank_app/utils/service_exception.dart';
import 'dart:developer' as dev;

class StorageService {
  final postImagePath = 'image/PostImage';
  final getImagePath = 'image/GetObtenerImage';

  final extensionImage = '.JPEG';
  static StorageService _instance = StorageService._privateConstructor();
  static StorageService get instance => _instance;
  StorageService._privateConstructor();

  final _httpService = HttpService.instance;

  Future<String> postImage({File image, String typeImage}) async {
    try {
      dynamic data = await _httpService.postImage(
          image: image,
          path: postImagePath,
          extensionImage: extensionImage,
          params: {'clase': 'imagen', 'tipo': typeImage});
      return data;
    } catch (e) {
      dev.log(e.toString(), name: 'StorageService.postImage');
      throw ServiceException(e.message);
    }
  }

  Future<Uint8List> getImage({String imagePath}) async {
    try {
      Uint8List data = await _httpService
          .getImage(getImagePath, params: {'filePath': imagePath});
      return data;
    } catch (e) {
      dev.log(e.toString(), name: 'StorageService.getImage');
      throw ServiceException(e.message);
    }
  }
}
