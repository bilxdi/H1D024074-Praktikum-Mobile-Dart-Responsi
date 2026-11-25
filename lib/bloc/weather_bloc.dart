import 'dart:convert';

import 'package:belajarflutter/helpers/api.dart';
import 'package:belajarflutter/helpers/api_url.dart';
import 'package:belajarflutter/model/cuaca.dart';
import 'package:belajarflutter/model/lokasi.dart';

class WeatherBloc {
  static Future<DataCuaca> getCuaca({required Lokasi lokasi}) async {
    String apiUrl = ApiUrl.forecast(lokasi.latitude!, lokasi.longitude!);
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    return DataCuaca.fromJson(jsonObj as Map<String, dynamic>);
  }

  static Future<List<Lokasi>> searchLokasi({required String nama}) async {
    String apiUrl = ApiUrl.searchLocation(nama);
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body) as Map<String, dynamic>;

    List<Lokasi> listLokasi = [];
    // Jika tidak ada hasil, Open-Meteo tidak mengirim key "results"
    if (jsonObj['results'] == null) return listLokasi;

    List<dynamic> results = jsonObj['results'];
    for (int i = 0; i < results.length; i++) {
      listLokasi.add(Lokasi.fromJson(results[i]));
    }
    return listLokasi;
  }
}