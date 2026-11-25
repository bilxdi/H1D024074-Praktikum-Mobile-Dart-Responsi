import 'package:flutter/foundation.dart';
import 'package:belajarflutter/bloc/weather_bloc.dart';
import 'package:belajarflutter/helpers/local_storage.dart';
import 'package:belajarflutter/model/cuaca.dart';
import 'package:belajarflutter/model/lokasi.dart';

enum StatusData { initial, loading, success, empty, error }

class WeatherViewModel extends ChangeNotifier {
  final LocalStorage _storage = LocalStorage();
  int _idRequestCuaca = 0;
  int _idRequestCari = 0;

  // Lokasi default jika belum ada lokasi terakhir yang tersimpan
  Lokasi lokasiTerpilih = Lokasi(
    nama: 'Jakarta',
    wilayah: 'Daerah Khusus Ibukota Jakarta',
    negara: 'Indonesia',
    latitude: -6.21462,
    longitude: 106.84513,
  );

  // State halaman cuaca
  DataCuaca? dataCuaca;
  StatusData statusCuaca = StatusData.initial;
  String pesanCuaca = '';

  // State halaman pencarian
  List<Lokasi> hasilPencarian = [];
  StatusData statusCari = StatusData.initial;
  String pesanCari = '';

  // Data Local Storage
  List<Lokasi> favorit = [];
  List<String> riwayat = [];

  Future<void> init() async {
    favorit = await _storage.getFavorit();
    riwayat = await _storage.getRiwayat();
    Lokasi? terakhir = await _storage.getLokasiTerakhir();
    if (terakhir != null) lokasiTerpilih = terakhir;
    notifyListeners();
    await loadCuaca();
  }

  Future<void> loadCuaca() async {
    int idRequest = ++_idRequestCuaca;
    statusCuaca = StatusData.loading;
    notifyListeners();

    try {
      DataCuaca data = await WeatherBloc.getCuaca(lokasi: lokasiTerpilih);
      if (idRequest != _idRequestCuaca) return;
      dataCuaca = data;
      statusCuaca = data.harian.isEmpty ? StatusData.empty : StatusData.success;
    } catch (e) {
      if (idRequest != _idRequestCuaca) return;
      dataCuaca = null;
      pesanCuaca = e.toString();
      statusCuaca = StatusData.error;
    }
    notifyListeners();
  }

  Future<void> cariLokasi(String kataKunci) async {
    String nama = kataKunci.trim();
    if (nama.isEmpty) {
      resetPencarian();
      return;
    }

    int idRequest = ++_idRequestCari;
    statusCari = StatusData.loading;
    notifyListeners();

    try {
      List<Lokasi> hasil = await WeatherBloc.searchLokasi(nama: nama);
      if (idRequest != _idRequestCari) return;
      hasilPencarian = hasil;
      if (hasil.isEmpty) {
        statusCari = StatusData.empty;
      } else {
        statusCari = StatusData.success;
        await _tambahRiwayat(nama);
      }
    } catch (e) {
      if (idRequest != _idRequestCari) return;
      hasilPencarian = [];
      pesanCari = e.toString();
      statusCari = StatusData.error;
    }
    notifyListeners();
  }

  void resetPencarian() {
    _idRequestCari++;
    hasilPencarian = [];
    statusCari = StatusData.initial;
    notifyListeners();
  }

  Future<void> pilihLokasi(Lokasi lokasi) async {
    lokasiTerpilih = lokasi;
    await _storage.setLokasiTerakhir(lokasi);
    await loadCuaca();
  }

  bool isFavorit(Lokasi lokasi) {
    return favorit.any((e) => e.sama(lokasi));
  }

  // Mengembalikan true jika lokasi ditambahkan, false jika dihapus
  Future<bool> toggleFavorit(Lokasi lokasi) async {
    bool ditambahkan;
    if (isFavorit(lokasi)) {
      favorit.removeWhere((e) => e.sama(lokasi));
      ditambahkan = false;
    } else {
      favorit.insert(0, lokasi);
      ditambahkan = true;
    }
    notifyListeners();
    await _storage.setFavorit(favorit);
    return ditambahkan;
  }

  Future<void> _tambahRiwayat(String kataKunci) async {
    riwayat.removeWhere((e) => e.toLowerCase() == kataKunci.toLowerCase());
    riwayat.insert(0, kataKunci);
    if (riwayat.length > 10) riwayat = riwayat.sublist(0, 10);
    await _storage.setRiwayat(riwayat);
  }

  Future<void> hapusRiwayat(String kataKunci) async {
    riwayat.remove(kataKunci);
    notifyListeners();
    await _storage.setRiwayat(riwayat);
  }

  Future<void> hapusSemuaRiwayat() async {
    riwayat = [];
    notifyListeners();
    await _storage.setRiwayat(riwayat);
  }
}