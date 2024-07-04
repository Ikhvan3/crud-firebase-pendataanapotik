//Untuk berinteraksi dengan Firestore
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; //menginisialisasi Firebase
import 'package:flutter_application_1/screens/homescreen.dart';
import 'firebase_options.dart'; //konfigurasi Firebase yang dihasilkan oleh Firebase CLI

void main(List<String> args) async {
  //menginisialisasi binding Flutter dan Firebase
  WidgetsFlutterBinding.ensureInitialized();
  //menginisialisasi Firebase dengan konfigurasi yang sesuai untuk platform saat ini
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, //konfigurasi default yang dihasilkan oleh Firebase CLI
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppPendataan(),
    );
  }
}
