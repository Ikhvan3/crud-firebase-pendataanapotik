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
      appBar: AppBar(
        title: Text(docId == null ? 'Tambah Data' : 'Edit Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: kodePlgController,
              decoration: InputDecoration(labelText: 'Kode Pelanggan'),
            ),
            TextField(
              controller: namaPlgController,
              decoration: InputDecoration(labelText: 'Nama Pelanggan'),
            ),
            TextField(
              controller: umurPlgController,
              decoration: InputDecoration(labelText: 'Umur Pelanggan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onSave(kodePlgController.text, namaPlgController.text,
                    umurPlgController.text);
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
