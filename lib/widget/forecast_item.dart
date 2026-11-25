import 'package:flutter/material.dart';
import 'package:belajarflutter/helpers/weather_helper.dart';
import 'package:belajarflutter/model/cuaca.dart';

class ForecastItem extends StatelessWidget {
  final PrakiraanHarian prakiraan;
  final bool hariIni;

  const ForecastItem({
    Key? key,
    required this.prakiraan,
    this.hariIni = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String hari = hariIni
        ? 'Hari ini'
        : WeatherHelper.namaHari(prakiraan.tanggal);

    return Card(
      child: ListTile(
        leading: Icon(
          WeatherHelper.ikon(prakiraan.kodeCuaca),
          size: 32.0,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text('$hari, ${WeatherHelper.formatTanggal(prakiraan.tanggal)}'),
        subtitle: Text(
          '${WeatherHelper.deskripsi(prakiraan.kodeCuaca)} • Hujan ${prakiraan.peluangHujan ?? '-'}%',
        ),
        trailing: Text(
          '${WeatherHelper.suhu(prakiraan.suhuMax)} / ${WeatherHelper.suhu(prakiraan.suhuMin)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}