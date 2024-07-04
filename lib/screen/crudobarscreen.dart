// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class CrudPage extends StatefulWidget {
//   CrudPage({Key? key}) : super(key: key);

//   @override
//   State<CrudPage> createState() => _CrudPageState();
// }

// class _CrudPageState extends State<CrudPage> {
//   //controller untuk input data
//   final TextEditingController _kodeObatController = TextEditingController();
//   final TextEditingController _namaObatController = TextEditingController();

//   //Referensi ke Koleksi Firestore
//   final CollectionReference _obatCollection =
//       FirebaseFirestore.instance.collection('Obat');

//   void _createOrUpdateObat([DocumentSnapshot? documentSnapshot]) async {
//     //jika documentSnapshot tidak null,berarti akan mengedit data yang sudah ada dengan adat dari documentSnapshot
//     if (documentSnapshot != null) {
//       _kodeObatController.text = documentSnapshot['kode_obat'];
//       _namaObatController.text = documentSnapshot['nama_obat'];
//     }
//     //akan menampilkan form input/update data
//     await showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       color: const Color.fromARGB(255, 124, 124, 124)),
//                   borderRadius: BorderRadius.circular(20),
//                   color: Color.fromARGB(255, 118, 240, 249),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: _kodeObatController,
//                     decoration: const InputDecoration(
//                       labelText: 'Kode Obat',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       color: const Color.fromARGB(255, 124, 124, 124)),
//                   borderRadius: BorderRadius.circular(20),
//                   color: Color.fromARGB(255, 118, 240, 249),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: _namaObatController,
//                     decoration: const InputDecoration(
//                       labelText: 'Nama Obat',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 child: const Text(
//                   'Submit',
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 32, 139, 147),
//                   ),
//                 ),
//                 onPressed: () async {
//                   final String kodeObat = _kodeObatController.text;
//                   final String namaObat = _namaObatController.text;

//                   if (kodeObat != null && namaObat != null) {
//                     if (documentSnapshot != null) {
//                       await _obatCollection.doc(documentSnapshot.id).update({
//                         'kode_obat': kodeObat,
//                         'nama_obat': namaObat,
//                       });
//                     } else {
//                       await _obatCollection.add({
//                         'kode_obat': kodeObat,
//                         'nama_obat': namaObat,
//                       });
//                     }
//                     //Mengosongkan nilai dalam controller setelah data disimpan
//                     _kodeObatController.text = '';
//                     _namaObatController.text = '';

//                     Navigator.of(context).pop();
//                   }
//                 },
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _deleteObat(String id) async {
//     await _obatCollection.doc(id).delete();

//     ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
//       content: Text('You have successfully deleted an obat'),
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('CRUD Obat')),
//       //Menggunakan stream dari koleksi Obat untuk mendapatkan pembaruan real-time
//       body: StreamBuilder(
//         stream:
//             _obatCollection.snapshots(), //Mengambil stream dari koleksi Obat
//         //Fungsi builder yang menerima snapshot dari data Firestore.
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           //Jika snapshot.hasData adalah true, maka akan menampilkan data dalam bentuk list
//           if (snapshot.hasData) {
//             return ListView.builder(
//               //Menentukan jumlah item dalam list berdasarkan jumlah dokumen dalam snapshot
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 final DocumentSnapshot documentSnapshot =
//                     snapshot.data!.docs[index];
//                 return Card(
//                   color: Color.fromARGB(255, 118, 240, 249),
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text(documentSnapshot['nama_obat']),
//                     subtitle: Text(documentSnapshot['kode_obat']),
//                     trailing: SizedBox(
//                       width: 100,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () =>
//                                 //mengedit obat dengan data dari documentSnapshot
//                                 _createOrUpdateObat(documentSnapshot),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () =>
//                                 //menghapus obat berdasarkan id dokumen
//                                 _deleteObat(documentSnapshot.id),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//           //(snapshot.hasData adalah false), maka kita menampilkan indikator loading.
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _createOrUpdateObat(),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
