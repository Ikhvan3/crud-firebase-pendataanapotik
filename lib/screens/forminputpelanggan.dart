import 'package:flutter/material.dart';

class FormInputPelanggan extends StatelessWidget {
  final String? docId;
  final String? oldKodePlg;
  final String? kodePlg;
  final String? namaPlg;
  final String? umurPlg;
  final Function(String, String, String) onSave;

  FormInputPelanggan({
    this.docId,
    this.oldKodePlg,
    this.kodePlg,
    this.namaPlg,
    this.umurPlg,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final kodePlgController = TextEditingController(text: kodePlg);
    final namaPlgController = TextEditingController(text: namaPlg);
    final umurPlgController = TextEditingController(text: umurPlg);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 255, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 210, 252),
        title: Text(
          docId == null ? 'Tambah Data Pelanggan' : 'Edit Data Pelanggan',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Color.fromARGB(255, 101, 255, 234),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: kodePlgController,
                  decoration: InputDecoration(labelText: 'Kode Pelanggan'),
                ),
              ),
            ),
            Card(
              color: Color.fromARGB(255, 101, 255, 234),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: namaPlgController,
                  decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                ),
              ),
            ),
            Card(
              color: Color.fromARGB(255, 101, 255, 234),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: umurPlgController,
                  decoration: InputDecoration(labelText: 'Umur Pelanggan'),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onSave(kodePlgController.text, namaPlgController.text,
                    umurPlgController.text);
                Navigator.of(context).pop();
              },
              child: Text(
                'Simpan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
