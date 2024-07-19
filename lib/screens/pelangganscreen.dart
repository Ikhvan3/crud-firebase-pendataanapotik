import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/forminputpelanggan.dart';
import 'package:http/http.dart' as http;
import 'formadddata.dart';

class PendataanPelangganFurniture extends StatefulWidget {
  @override
  State<PendataanPelangganFurniture> createState() =>
      _PendataanPelangganFurnitureState();
}

class _PendataanPelangganFurnitureState
    extends State<PendataanPelangganFurniture> {
  final corref = FirebaseFirestore.instance.collection('Pelanggan');
  late List<Map<String, dynamic>> listdata = [];

  _tampildata() async {
    // Kosongkan listdata terlebih dahulu
    listdata = [];

    // Ambil data dari Firebase
    final firebaseData = await corref.get();
    List<Map<String, dynamic>> firebaseList = firebaseData.docs.map((doc) {
      var docData = doc.data() as Map<String, dynamic>;
      docData['id'] = doc.id;
      docData['source'] = 'firebase';
      return docData;
    }).toList();

    // Ambil data dari MySQL
    List<Map<String, dynamic>> mysqlList = await _tampilDataMySQL();

    // Gabungkan data dari kedua sumber
    listdata.addAll(firebaseList);
    listdata.addAll(mysqlList);

    // Hapus duplikat berdasarkan kode_pelanggan, prioritaskan data dari Firebase
    final Map<String, Map<String, dynamic>> uniqueMap = {};
    for (var item in listdata) {
      String key = item['kode_pelanggan'];
      if (!uniqueMap.containsKey(key) || item['source'] == 'firebase') {
        uniqueMap[key] = item;
      }
    }
    listdata = uniqueMap.values.toList();

    setState(() {});
  }

  Future<List<Map<String, dynamic>>> _tampilDataMySQL() async {
    List<Map<String, dynamic>> mysqlList = [];
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.27/getpelanggan.php'));

      if (response.statusCode == 200) {
        // Tambahkan logging untuk melihat respons dari server
        print("Raw response from MySQL: ${response.body}");

        // Decode respons JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Periksa apakah operasi berhasil
        if (responseData['success'] == true) {
          // Ambil data dari kunci 'data'
          List<dynamic> data = responseData['data'];
          print("Data dari MySQL: $data");

          mysqlList = data
              .where((item) =>
                  item['kode_pelanggan'] != null &&
                  item['kode_pelanggan'] != '0' &&
                  item['nama_pelanggan'] != null &&
                  item['nama_pelanggan'] != '0' &&
                  item['umur_pelanggan'] != null &&
                  item['umur_pelanggan'] != '0' &&
                  item['email'] != null &&
                  item['email'] != '0' &&
                  item['telepon'] != null &&
                  item['telepon'] != '0')
              .map((item) => {
                    'id': item['id'].toString(),
                    'kode_pelanggan': item['kode_pelanggan'],
                    'nama_pelanggan': item['nama_pelanggan'],
                    'umur_pelanggan': item['umur_pelanggan'],
                    'email': item['email'],
                    'telepon': item['telepon'],
                    'source': 'mysql'
                  })
              .toList();
        } else {
          print('Gagal mengambil data dari MySQL: ${responseData['error']}');
        }
      } else {
        print('Gagal mengambil data dari MySQL: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error dalam _tampilDataMySQL: $e');
    }
    return mysqlList;
  }

  @override
  void initState() {
    super.initState();
    _tampildata();
  }

  void _addData(String kodePlg, String namaPlg, String umurPlg, String emailPlg,
      String teleponPlg) async {
    if (kodePlg.isNotEmpty &&
        namaPlg.isNotEmpty &&
        umurPlg.isNotEmpty &&
        emailPlg.isNotEmpty &&
        teleponPlg.isNotEmpty) {
      try {
        // Tambah ke Firebase
        DocumentReference docRef = await corref.add({
          'kode_pelanggan': kodePlg,
          'nama_pelanggan': namaPlg,
          'umur_pelanggan': umurPlg,
          'email': emailPlg,
          'telepon': teleponPlg,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Tambah ke MySQL
        final response = await http.post(
          Uri.parse('http://192.168.1.27/addpelanggan.php'),
          body: {
            'kode_pelanggan': kodePlg,
            'nama_pelanggan': namaPlg,
            'umur_pelanggan': umurPlg,
            'email': emailPlg,
            'telepon': teleponPlg,
          },
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result['success']) {
            print('Data berhasil ditambahkan ke Firebase dan MySQL');
            _tampildata();
          } else {
            print('Kesalahan menambahkan ke MySQL: ${result['error']}');
            await docRef.delete();
          }
        } else {
          print('Kesalahan HTTP: ${response.statusCode}');
          await docRef.delete();
        }
      } catch (e) {
        print('Terjadi pengecualian: $e');
      }
    } else {
      print('Kode pelanggan dan nama pelanggan tidak boleh kosong');
    }
  }

  void _deleteData(String docId, String kodePelanggan) async {
    try {
      // Hapus dari Firebase
      await corref.doc(docId).delete();
      _tampildata();

      // Hapus dari MySQL
      final response = await http.post(
        Uri.parse('http://192.168.1.27/deletepelanggan.php'),
        body: {'kode_pelanggan': kodePelanggan},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('Data berhasil dihapus dari Firebase dan MySQL');
        } else {
          print('Kesalahan menghapus dari MySQL: ${result['error']}');
        }
      } else {
        print(
            'Kesalahan HTTP saat menghapus dari MySQL: ${response.statusCode}');
      }

      await _tampildata(); // Gunakan await di sini
    } catch (e) {
      print('Terjadi pengecualian saat menghapus data: $e');
    }
  }

  void _editData(
      String docId,
      String oldKodePlg,
      String newKodePlg,
      String namaPlg,
      String umurPlg,
      String emailPlg,
      String teleponPlg) async {
    if (newKodePlg.isNotEmpty &&
        namaPlg.isNotEmpty &&
        umurPlg.isNotEmpty &&
        emailPlg.isNotEmpty &&
        teleponPlg.isNotEmpty) {
      try {
        // Perbarui data di Firebase
        await corref.doc(docId).update({
          'kode_pelanggan': newKodePlg,
          'nama_pelanggan': namaPlg,
          'umur_pelanggan': umurPlg,
          'email': emailPlg,
          'telepon': teleponPlg,
        });

        // Perbarui data di MySQL
        final response = await http.post(
          Uri.parse('http://192.168.1.27/editpelanggan.php'),
          body: {
            'old_kode_pelanggan': oldKodePlg,
            'new_kode_pelanggan': newKodePlg,
            'nama_pelanggan': namaPlg,
            'umur_pelanggan': umurPlg,
            'email': emailPlg,
            'telepon': teleponPlg,
          },
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result['success']) {
            print('Data berhasil diubah di Firebase dan MySQL');
            await _tampildata();
          } else {
            print('Kesalahan mengubah data di MySQL: ${result['error']}');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Gagal mengubah data: ${result['error']}')),
            );
          }
        } else {
          print(
              'Kesalahan HTTP saat mengubah data di MySQL: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal mengubah data. Status: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Terjadi pengecualian saat mengubah data: $e');
      }
    } else {
      print('Kode pelanggan dan nama pelanggan tidak boleh kosong');
    }
  }

  Future<void> _navigateToForm({
    String? docId,
    String? oldKodePlg,
    String? kodePlg,
    String? namaPlg,
    String? umurPlg,
    String? emailPlg,
    String? teleponPlg,
  }) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FormInputPelanggan(
        docId: docId,
        oldKodePlg: oldKodePlg,
        kodePlg: kodePlg,
        namaPlg: namaPlg,
        umurPlg: umurPlg,
        emailPlg: emailPlg,
        teleponPlg: teleponPlg,
        onSave: (newKodePlg, newNamaPlg, newUmurPlg, newEmailPlg,
            newTeleponPlg) async {
          if (docId == null) {
            _addData(
                newKodePlg, newNamaPlg, newUmurPlg, newEmailPlg, newTeleponPlg);
          } else {
            _editData(docId, oldKodePlg!, newKodePlg, newNamaPlg, newUmurPlg,
                newEmailPlg, newTeleponPlg);
          }
          await _tampildata(); // Refresh data setelah edit
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 255, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 210, 252),
        title: Text(
          'PENDATAAN PELANGGAN',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: ListView.builder(
        itemCount: listdata.length,
        itemBuilder: (context, index) {
          final data = listdata[index];
          return Card(
            color: Color.fromARGB(255, 101, 255, 234),
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['kode_pelanggan'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\Nama Pelanggan : ${data['nama_pelanggan']}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\Umur Pelanggan : ${data['umur_pelanggan']}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\Email : ${data['email']}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\Telepon : ${data['telepon']}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _navigateToForm(
                      docId: data['id'],
                      oldKodePlg: data['kode_pelanggan'],
                      kodePlg: data['kode_pelanggan'],
                      namaPlg: data['nama_pelanggan'],
                      umurPlg: data['umur_pelanggan'],
                      emailPlg: data['email'],
                      teleponPlg: data['telepon'],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _deleteData(data['id'], data['kode_pelanggan']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToForm(),
      ),
    );
  }
}
