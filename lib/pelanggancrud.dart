// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class PendataanPelanggan extends StatefulWidget {
//   @override
//   State<PendataanPelanggan> createState() => _PendataanPelangganState();
// }

// class _PendataanPelangganState extends State<PendataanPelanggan> {
//   final corref = FirebaseFirestore.instance.collection('Pelanggan');
//   late List<Map<String, dynamic>> listdata = [];

//   _tampildata() async {
//     final data = await corref.get();
//     listdata = data.docs.map((doc) {
//       var docData = doc.data();
//       docData['id'] = doc.id;
//       return docData;
//     }).toList();

//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     _tampildata();
//   }

//   void _addData(String kodePlnggan, String namaPlnggan) async {
//     await corref
//         .add({'kode_pelanggan': kodePlnggan, 'nama_pelanggan': namaPlnggan});
//     _tampildata();
//   }

//   void _editData(String docId, String kodePlnggan, String namaPlnggan) async {
//     await corref
//         .doc(docId)
//         .update({'kode_pelanggan': kodePlnggan, 'nama_pelanggan': namaPlnggan});
//     _tampildata();
//   }

//   void _deleteData(String docId) async {
//     await corref.doc(docId).delete();
//     _tampildata();
//   }

//   void _showForm({String? docId, String? kodePlnggan, String? namaPlnggan}) {
//     final kodePlngganController = TextEditingController(text: kodePlnggan);
//     final namaPlngganController = TextEditingController(text: namaPlnggan);
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Text(
//             docId == null ? 'Tambah Data' : 'Edit Data',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: Container(
//             width: 300,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                         color: const Color.fromARGB(255, 124, 124, 124)),
//                     borderRadius: BorderRadius.circular(20),
//                     color: Color.fromARGB(255, 118, 240, 249),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: kodePlngganController,
//                       decoration: InputDecoration(
//                         labelText: 'Kode Pelanggan',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                         color: const Color.fromARGB(255, 124, 124, 124)),
//                     borderRadius: BorderRadius.circular(20),
//                     color: Color.fromARGB(255, 118, 240, 249),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: namaPlngganController,
//                       decoration: InputDecoration(
//                         labelText: 'Nama Pelanggan',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(); // Ini akan menutup dialog
//               },
//               child: Text('Batal'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (docId == null) {
//                   _addData(
//                       kodePlngganController.text, namaPlngganController.text);
//                 } else {
//                   _editData(docId, kodePlngganController.text,
//                       namaPlngganController.text);
//                 }
//                 Navigator.of(dialogContext).pop();
//               },
//               child: Text('Simpan'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 96, 96, 96),
//         title: Text(
//           'LISTVIEW PENDATAAN PELANGGAN',
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Color.fromARGB(255, 3, 255, 221)),
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: listdata.length,
//         itemBuilder: (context, index) {
//           final data = listdata[index];
//           return Card(
//             color: Color.fromARGB(255, 101, 255, 234),
//             margin: EdgeInsets.all(10),
//             child: ListTile(
//               title: Text(
//                 data['kode_pelanggan'],
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(data['nama_pelanggan']),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit),
//                     onPressed: () => _showForm(
//                       docId: data['id'],
//                       kodePlnggan: data['kode_pelanggan'],
//                       namaPlnggan: data['nama_pelanggan'],
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () => _deleteData(data['id']),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () => _showForm(),
//       ),
//     );
//   }
// }
