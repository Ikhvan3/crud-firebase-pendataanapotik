import 'package:flutter/material.dart';

class FormInputScreen extends StatelessWidget {
  final String? docId;
  final String? oldKodeBrg;
  final String? kodeBrg;
  final String? namaBrg;
  final String? hargaBrg;
  final Function(String, String, String) onSave;

  FormInputScreen({
    this.docId,
    this.oldKodeBrg,
    this.kodeBrg,
    this.namaBrg,
    this.hargaBrg,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final kodeBrgController = TextEditingController(text: kodeBrg);
    final namaBrgController = TextEditingController(text: namaBrg);
    final hargaBrgController = TextEditingController(text: hargaBrg);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 255, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 210, 252),
        title: Text(
          docId == null ? 'Tambah Data' : 'Edit Data',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: kodeBrgController,
              decoration: InputDecoration(labelText: 'Kode Barang'),
            ),
            TextField(
              controller: namaBrgController,
              decoration: InputDecoration(labelText: 'Nama Barang'),
            ),
            TextField(
              controller: hargaBrgController,
              decoration: InputDecoration(labelText: 'Harga Barang'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onSave(kodeBrgController.text, namaBrgController.text,
                    hargaBrgController.text);
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
