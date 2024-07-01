class Obat {
  String id;
  String kodeObat;
  String namaObat;

  Obat({required this.id, required this.kodeObat, required this.namaObat});

  Map<String, dynamic> toMap() {
    return {
      'kode_obat': kodeObat,
      'nama_obat': namaObat,
    };
  }

  static Obat fromMap(String id, Map<String, dynamic> map) {
    return Obat(
      id: id,
      kodeObat: map['kode_obat'],
      namaObat: map['nama_obat'],
    );
  }
}
