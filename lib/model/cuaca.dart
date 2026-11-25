class CuacaSaatIni {
  double? suhu;
  int? kelembapan;
  double? suhuTerasa;
  double? curahHujan;
  int? kodeCuaca;
  double? kecepatanAngin;

  CuacaSaatIni({
    this.suhu,
    this.kelembapan,
    this.suhuTerasa,
    this.curahHujan,
    this.kodeCuaca,
    this.kecepatanAngin,
  });

  factory CuacaSaatIni.fromJson(Map<String, dynamic> obj) {
    return CuacaSaatIni(
      suhu: double.tryParse(obj['temperature_2m'].toString()),
      kelembapan: int.tryParse(obj['relative_humidity_2m'].toString()),
      suhuTerasa: double.tryParse(obj['apparent_temperature'].toString()),
      curahHujan: double.tryParse(obj['precipitation'].toString()),
      kodeCuaca: int.tryParse(obj['weather_code'].toString()),
      kecepatanAngin: double.tryParse(obj['wind_speed_10m'].toString()),
    );
  }
}

class PrakiraanHarian {
  String? tanggal;
  int? kodeCuaca;
  double? suhuMax;
  double? suhuMin;
  int? peluangHujan;

  PrakiraanHarian({
    this.tanggal,
    this.kodeCuaca,
    this.suhuMax,
    this.suhuMin,
    this.peluangHujan,
  });
}

class DataCuaca {
  CuacaSaatIni? saatIni;
  List<PrakiraanHarian> harian;

  DataCuaca({this.saatIni, this.harian = const []});

  factory DataCuaca.fromJson(Map<String, dynamic> obj) {
    var current = obj['current'] as Map<String, dynamic>;
    var daily = obj['daily'] as Map<String, dynamic>;

    List<dynamic> tanggal = daily['time'];
    List<dynamic> kode = daily['weather_code'];
    List<dynamic> suhuMax = daily['temperature_2m_max'];
    List<dynamic> suhuMin = daily['temperature_2m_min'];
    List<dynamic> peluang = daily['precipitation_probability_max'];

    List<PrakiraanHarian> harian = [];
    for (int i = 0; i < tanggal.length; i++) {
      harian.add(PrakiraanHarian(
        tanggal: tanggal[i].toString(),
        kodeCuaca: int.tryParse(kode[i].toString()),
        suhuMax: double.tryParse(suhuMax[i].toString()),
        suhuMin: double.tryParse(suhuMin[i].toString()),
        peluangHujan: int.tryParse(peluang[i].toString()),
      ));
    }

    return DataCuaca(
      saatIni: CuacaSaatIni.fromJson(current),
      harian: harian,
    );
  }

  // Peluang hujan hari ini diambil dari data harian (index 0)
  int? get peluangHujanHariIni {
    return harian.isNotEmpty ? harian[0].peluangHujan : null;
  }
}