import 'package:intl/intl.dart';

class Mahasiswa {
  final int id;
  final String nama;
  final String nim;
  final String description;
  final String createdAt;
  final String image;
  Mahasiswa(
      {required this.id,
      required this.nama,
      required this.nim,
      required this.description,
      required this.createdAt,
      required this.image});

  factory Mahasiswa.fromJson(Map<String, dynamic> map) {
    return Mahasiswa(
        id: map['id'],
        nama: map['nama'],
        nim: map['nim'],
        description: map['description'],
        createdAt: map['createdAt'],
        image: map['image']);
  }

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'nim': nim,
        'description': description,
        'createdAt': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        'image': image
      };
}
