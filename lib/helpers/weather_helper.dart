import 'package:flutter/material.dart';

class WeatherHelper {
  // Kode cuaca mengikuti standar WMO (dipakai oleh Open-Meteo)
  static String deskripsi(int? kode) {
    switch (kode) {
      case 0:
        return 'Cerah';
      case 1:
        return 'Cerah berawan';
      case 2:
        return 'Berawan sebagian';
      case 3:
        return 'Mendung';
      case 45:
      case 48:
        return 'Berkabut';
      case 51:
      case 53:
      case 55:
        return 'Gerimis';
      case 56:
      case 57:
        return 'Gerimis beku';
      case 61:
        return 'Hujan ringan';
      case 63:
        return 'Hujan sedang';
      case 65:
        return 'Hujan lebat';
      case 66:
      case 67:
        return 'Hujan beku';
      case 71:
      case 73:
      case 75:
        return 'Salju';
      case 77:
        return 'Butiran salju';
      case 80:
      case 81:
      case 82:
        return 'Hujan deras sesaat';
      case 85:
      case 86:
        return 'Hujan salju';
      case 95:
        return 'Badai petir';
      case 96:
      case 99:
        return 'Badai petir disertai hujan es';
      default:
        return 'Tidak diketahui';
    }
  }

  static IconData ikon(int? kode) {
    switch (kode) {
      case 0:
        return Icons.wb_sunny;
      case 1:
      case 2:
        return Icons.wb_cloudy;
      case 3:
        return Icons.cloud;
      case 45:
      case 48:
        return Icons.blur_on;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return Icons.grain;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return Icons.water_drop;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Icons.ac_unit;
      case 95:
      case 96:
      case 99:
        return Icons.flash_on;
      default:
        return Icons.help_outline;
    }
  }

  static String suhu(double? nilai) {
    if (nilai == null) return '-';
    return '${nilai.round()}°C';
  }

  static String namaHari(String? tanggal) {
    if (tanggal == null) return '-';
    DateTime? d = DateTime.tryParse(tanggal);
    if (d == null) return tanggal;
    const hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return hari[d.weekday - 1];
  }

  static String formatTanggal(String? tanggal) {
    if (tanggal == null) return '-';
    DateTime? d = DateTime.tryParse(tanggal);
    if (d == null) return tanggal;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }
}