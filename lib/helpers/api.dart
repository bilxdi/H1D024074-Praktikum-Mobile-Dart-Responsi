import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'app_exception.dart';

class Api {
  Future<dynamic> get(dynamic url) async {
    var responseJson;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    } on TimeoutException {
      throw FetchDataException('Koneksi timeout, silakan coba lagi');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}