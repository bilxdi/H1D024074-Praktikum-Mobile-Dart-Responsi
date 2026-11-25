class Lokasi {
  int? id;
  String? nama;
  String? wilayah;
  String? negara;
  double? latitude;
  double? longitude;

  Lokasi({
    this.id,
    this.nama,
    this.wilayah,
    this.negara,
    this.latitude,
    this.longitude,
  });

  // Key JSON sama dengan response Geocoding API agar bisa dipakai
  // untuk parsing API sekaligus membaca data dari Local Storage
  factory Lokasi.fromJson(Map<String, dynamic> obj) {
    return Lokasi(
      id: int.tryParse(obj['id'].toString()),
      nama: obj['name'],
      wilayah: obj['admin1'],
      negara: obj['country'],
      latitude: double.tryParse(obj['latitude'].toString()),
      longitude: double.tryParse(obj['longitude'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": nama,
      "admin1": wilayah,
      "country": negara,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  String get detail {
    List<String> bagian = [];
    if (wilayah != null && wilayah!.isNotEmpty && wilayah != nama) {
      bagian.add(wilayah!);
    }
    if (negara != null && negara!.isNotEmpty) {
      bagian.add(negara!);
    }
    return bagian.join(', ');
  }

  bool sama(Lokasi lain) {
    return latitude == lain.latitude && longitude == lain.longitude;
  }
}