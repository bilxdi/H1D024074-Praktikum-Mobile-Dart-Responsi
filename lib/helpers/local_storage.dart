import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:belajarflutter/model/lokasi.dart';

class LocalStorage {
  static const String _keyFavorit = "favorit";
  static const String _keyRiwayat = "riwayat";
  static const String _keyLokasiTerakhir = "lokasiTerakhir";

  Future setFavorit(List<Lokasi> list) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data = list.map((e) => json.encode(e.toJson())).toList();
    return pref.setStringList(_keyFavorit, data);
  }

  Future<List<Lokasi>> getFavorit() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data = pref.getStringList(_keyFavorit) ?? [];
    return data
        .map((e) => Lokasi.fromJson(json.decode(e) as Map<String, dynamic>))
        .toList();
  }

  Future setRiwayat(List<String> list) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setStringList(_keyRiwayat, list);
  }

  Future<List<String>> getRiwayat() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(_keyRiwayat) ?? [];
  }

  Future setLokasiTerakhir(Lokasi lokasi) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(_keyLokasiTerakhir, json.encode(lokasi.toJson()));
  }

  Future<Lokasi?> getLokasiTerakhir() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? data = pref.getString(_keyLokasiTerakhir);
    if (data == null) return null;
    return Lokasi.fromJson(json.decode(data) as Map<String, dynamic>);
  }
}