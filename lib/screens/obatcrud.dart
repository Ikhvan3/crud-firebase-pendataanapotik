import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'formadddata.dart';

class PendataanBarangFurniture extends StatefulWidget {
  @override
  State<PendataanBarangFurniture> createState() =>
      _PendataanBarangFurnitureState();
}

class _PendataanBarangFurnitureState extends State<PendataanBarangFurniture> {
  final corref = FirebaseFirestore.instance.collection('Barang');
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

    // Hapus duplikat berdasarkan kode_barang, prioritaskan data dari Firebase
    final Map<String, Map<String, dynamic>> uniqueMap = {};
    for (var item in listdata) {
      String key = item['kode_barang'];
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
          await http.get(Uri.parse('http://192.168.33.195/get_furniture.php'));

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
                  item['kode_barang'] != null &&
                  item['kode_barang'] != '0' &&
                  item['nama_barang'] != null &&
                  item['nama_barang'] != '0' &&
                  item['harga_barang'] != null &&
                  item['harga_barang'] != '0')
              .map((item) => {
                    'id': item['id'].toString(),
                    'kode_barang': item['kode_barang'],
                    'nama_barang': item['nama_barang'],
                    'harga_barang': item['harga_barang'],
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

  void _addData(String kodeBrg, String namaBrg, String hargaBrg) async {
    if (kodeBrg.isNotEmpty && namaBrg.isNotEmpty && hargaBrg.isNotEmpty) {
      try {
        // Tambah ke Firebase
        DocumentReference docRef = await corref.add({
          'kode_barang': kodeBrg,
          'nama_barang': namaBrg,
          'harga_barang': hargaBrg,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Tambah ke MySQL
        final response = await http.post(
          Uri.parse('http://192.168.33.195/add_furniture.php'),
          body: {
            'kode_barang': kodeBrg,
            'nama_barang': namaBrg,
            'harga_barang': hargaBrg,
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
      print('Kode barag dan nama barang tidak boleh kosong');
    }
  }

  void _deleteData(String docId, String kodeBarang) async {
    try {
      // Hapus dari Firebase
      await corref.doc(docId).delete();
      _tampildata();

      // Hapus dari MySQL
      final response = await http.post(
        Uri.parse('http://192.168.33.195/delete_furniture.php'),
        body: {'kode_barang': kodeBarang},
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

  void _editData(String docId, String oldKodeBrg, String newKodeBrg,
      String namaBrg, String hargaBrg) async {
    if (newKodeBrg.isNotEmpty && namaBrg.isNotEmpty && hargaBrg.isNotEmpty) {
      try {
        // Perbarui data di Firebase
        await corref.doc(docId).update({
          'kode_barang': newKodeBrg,
          'nama_barang': namaBrg,
          'harga_barang': hargaBrg,
        });

        // Perbarui data di MySQL
        final response = await http.post(
          Uri.parse('http://192.168.33.195/edit_furniture.php'),
          body: {
            'old_kode_barang': oldKodeBrg,
            'new_kode_barang': newKodeBrg,
            'nama_barang': namaBrg,
            'harga_barang': hargaBrg,
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
      print('Kode barang dan nama barang tidak boleh kosong');
    }
  }

  Future<void> _navigateToForm({
    String? docId,
    String? oldKodeBrg,
    String? kodeBrg,
    String? namaBrg,
    String? hargaBrg,
  }) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FormInputScreen(
        docId: docId,
        oldKodeBrg: oldKodeBrg,
        kodeBrg: kodeBrg,
        namaBrg: namaBrg,
        hargaBrg: hargaBrg,
        onSave: (newKodeBrg, newNamaBrg, newHargaBrg) async {
          if (docId == null) {
            _addData(newKodeBrg, newNamaBrg, newHargaBrg);
          } else {
            _editData(docId, oldKodeBrg!, newKodeBrg, newNamaBrg, newHargaBrg);
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
          'PENDATAAN BARANG',
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
                    data['kode_barang'],
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
                      "\Nama Barang : ${data['nama_barang']}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\Harga Barang : ${data['harga_barang']}",
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
                      oldKodeBrg: data['kode_barang'],
                      kodeBrg: data['kode_barang'],
                      namaBrg: data['nama_barang'],
                      hargaBrg: data['harga_barang'],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _deleteData(data['id'], data['kode_barang']),
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
