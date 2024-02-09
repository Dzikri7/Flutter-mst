import 'package:flutter/material.dart';
import 'package:tugas_mahasiswa/bottomnav.dart';
import 'package:tugas_mahasiswa/mahasiswa/mahasiswa.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pemrog Flutter',
      home: BottomNav(), // Mengganti MyHomePage() dengan BottomNav()
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Belajar Flutter'),
      ),
      body: Center(
        child: Text(
          'Selamat Datang di Kampus ULBI',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
