import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:microbank_app/utils/http_exception.dart';
import 'dart:convert';

import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/utils.dart';

class HttpService {
  static HttpService _instance = HttpService._privateConstructor();
  static HttpService get instance => _instance;
  HttpService._privateConstructor();
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  Map<String, String> headersOctet = {
    'Content-Type': 'application/octet-stream',
  };

  Future<dynamic> get(String path,
      {Map<String, String> params, Map<String, String> headers}) async {
    dev.log('Llamado al Http Get con path $path', name: 'HttpService.get');
    var url = Uri.http(kBaseUrlService, kComplementUrl + path, params);
    var response = await http.get(url, headers: headers);
    dynamic data;
    if (response.statusCode == 200) {
      data = jsonDecode(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      data = jsonDecode(response.body);
      throw HttpException(
          statusCode: response.statusCode,
          error: data['error'],
          message: data['message']);
    } else {
      throw HttpException(message: kMensajeErrorGenerico);
    }
    dev.log('Data $data', name: 'HttpService.get');
    return data;
  }

  Future<dynamic> post(String path,
      {Map<String, String> params, Map<String, String> headersParam}) async {
    dev.log('Llamado al Http Post con path $path', name: 'HttpService.post');
    var url = Uri.http(kBaseUrlService, kComplementMovilUrl + path);
    var response = await http.post(url,
        body: jsonEncode(params), headers: headersParam ?? headers);
    dynamic data;
    if (response.statusCode == 200) {
      data = jsonDecode(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      data = jsonDecode(response.body);
      throw HttpException(
          statusCode: response.statusCode,
          error: data['error'],
          message: data['message']);
    } else {
      throw HttpException(message: kMensajeErrorGenerico);
    }
    dev.log('Data $data', name: 'HttpService.post');
    return data;
  }

  Future<dynamic> postImage(
      {String path,
      File image,
      String extensionImage,
      Map<String, String> params}) async {
    dev.log('Llamado al Http Post Image con path $path',
        name: 'HttpService.postImage');
    var url = Uri.http(kBaseUrlService, kComplementStorageUrl + path);
    var request = http.MultipartRequest('POST', url);
    request.files.add(
      http.MultipartFile.fromBytes('uploadFile', image.readAsBytesSync(),
          filename:
              dateToString(format: 'yyyyMMddHHmmss', dateTime: DateTime.now()) +
                  extensionImage),
    );
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      "Access-Control-Allow-Origin": "*",
    });
    request.fields.addAll(params);
    http.StreamedResponse streamedResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    dynamic data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      data = jsonDecode(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 404) {
      data = jsonDecode(response.body);
      print(data);
      throw HttpException(
          statusCode: response.statusCode,
          error: data['error'],
          message: data['error']);
    } else {
      throw HttpException(message: kMensajeErrorGenerico);
    }
    dev.log('Data $data', name: 'HttpService.postImage');
    return data;
  }

  Future<void> put(String path,
      {Map<String, dynamic> params, Map<String, String> headersParam}) async {
    dev.log('Llamado al Http Put con path $path y params $params',
        name: 'HttpService.put');
    var url = Uri.http(kBaseUrlService, kComplementMovilUrl + path);
    var response = await http.put(url,
        body: jsonEncode(params), headers: headersParam ?? headers);
    dynamic data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      data = jsonDecode(response.body);
      throw HttpException(
          statusCode: response.statusCode,
          error: data['error'],
          message: data['message']);
    } else {
      throw HttpException(message: kMensajeErrorGenerico);
    }
  }

  Future<Uint8List> getImage(String path, {Map<String, String> params}) async {
    dev.log('Llamado al Http Get Image con path $path',
        name: 'HttpService.getImage');
    var url = Uri.http(kBaseUrlService, kComplementStorageUrl + path, params);
    var response = await http.get(url, headers: headersOctet);
    dynamic data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      data = response.body;
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      data = response.body;
      throw HttpException(
          statusCode: response.statusCode,
          error: data['error'],
          message: data['message']);
    } else {
      throw HttpException(message: kMensajeErrorGenerico);
    }
    dev.log('Data ...imagen ...', name: 'HttpService.getImage');
    return response.bodyBytes;
  }
}
