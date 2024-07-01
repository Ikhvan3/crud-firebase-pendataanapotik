import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrudPagePelanggan extends StatefulWidget {
  CrudPagePelanggan({Key? key}) : super(key: key);

  @override
  State<CrudPagePelanggan> createState() => _CrudPagePelangganState();
}

class _CrudPagePelangganState extends State<CrudPagePelanggan> {
  final TextEditingController _kodePelangganController =
      TextEditingController();

  final TextEditingController _namaPelangganController =
      TextEditingController();

  final CollectionReference _pelangganCollection =
      FirebaseFirestore.instance.collection('Pelanggan');

  void _createOrUpdatePelanggan([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _kodePelangganController.text = documentSnapshot['kode_pelanggan'];
      _namaPelangganController.text = documentSnapshot['nama_pelanggan'];
    }

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              //add dan update data obat
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 124, 124, 124)),
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 118, 240, 249),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _kodePelangganController,
                    decoration: const InputDecoration(
                      labelText: 'Kode Pelanggan',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 124, 124, 124)),
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 118, 240, 249),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _namaPelangganController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pelanggan',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Color.fromARGB(255, 32, 139, 147),
                  ),
                ),
                onPressed: () async {
                  final String kodePelanggan = _kodePelangganController.text;
                  final String namaPelanggan = _namaPelangganController.text;

                  if (kodePelanggan != null && namaPelanggan != null) {
                    if (documentSnapshot != null) {
                      await _pelangganCollection
                          .doc(documentSnapshot.id)
                          .update({
                        'kode_pelanggan': kodePelanggan,
                        'nama_pelanggan': namaPelanggan,
                      });
                    } else {
                      await _pelangganCollection.add({
                        'kode_pelanggan': kodePelanggan,
                        'nama_pelanggan': namaPelanggan,
                      });
                    }

                    _kodePelangganController.text = '';
                    _namaPelangganController.text = '';
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _deletePelanggan(String id) async {
    await _pelangganCollection.doc(id).delete();

    ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
      content: Text('You have successfully deleted an pelanggan'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pendataan Pelanggan')),
      body: StreamBuilder(
        stream: _pelangganCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    snapshot.data!.docs[index];
                return Card(
                  color: Color.fromARGB(255, 118, 240, 249),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['nama_pelanggan']),
                    subtitle: Text(documentSnapshot['kode_pelanggan']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _createOrUpdatePelanggan(documentSnapshot),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deletePelanggan(documentSnapshot.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdatePelanggan(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
