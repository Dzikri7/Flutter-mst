import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const Dosen());

class Dosen extends StatelessWidget {
  const Dosen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Pemrog ULBI',
      initialRoute: '/',
      routes: {
        '/': (context) => const DataDosenListScreen(),
        '/add': (context) => const AddDataDosenScreen(),
      },
    );
  }
}

class DataDosen {
  final String nik;
  final String nama_dosen;
  final String kode_dosen;

  DataDosen({
    required this.nik,
    required this.nama_dosen,
    required this.kode_dosen,
  });

  factory DataDosen.fromJson(Map<String, dynamic> json) {
    return DataDosen(
      nik: json['nik'],
      nama_dosen: json['nama_dosen'],
      kode_dosen: json['kode_dosen'],
    );
  }
}

class DataDosenListScreen extends StatefulWidget {
  const DataDosenListScreen({Key? key}) : super(key: key);

  @override
  _DataDosenListScreenState createState() => _DataDosenListScreenState();
}

class _DataDosenListScreenState extends State<DataDosenListScreen> {
  List<DataDosen> DataDosens = [];

  Future<void> fetchDataDosens() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:80/ulbi2024/dosen.php'));

      if (response.statusCode == 200) {
        setState(() {
          Iterable list = json.decode(response.body);
          DataDosens = list.map((model) => DataDosen.fromJson(model)).toList();
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataDosens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data DataDosen"),
      ),
      body: ListView.builder(
        itemCount: DataDosens.length,
        itemBuilder: (context, index) {
          final DataDosen = DataDosens[index];
          return ListTile(
            title: Text(DataDosen.nama_dosen),
            subtitle: Text("Kode Dosen: ${DataDosen.kode_dosen}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((value) {
            if (value == true) {
              fetchDataDosens();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddDataDosenScreen extends StatefulWidget {
  const AddDataDosenScreen({Key? key}) : super(key: key);

  @override
  _AddDataDosenScreenState createState() => _AddDataDosenScreenState();
}

class _AddDataDosenScreenState extends State<AddDataDosenScreen> {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController nama_dosenController = TextEditingController();
  final TextEditingController kode_dosenController = TextEditingController();

  Future<void> addDataDosen() async {
    final String nik = nikController.text;
    final String nama_dosen = nama_dosenController.text;
    final String kode_dosen = kode_dosenController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:80/ulbi2024/dosen.php'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'nik': nik, 'nama_dosen': nama_dosen, 'kode_dosen': kode_dosen}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Data Data Dosen Berhasil di Tambah");
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: "Gagal menambah Data Data Dosen");
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding data: $error');
      Fluttertoast.showToast(msg: "Terjadi kesalahan saat menambah Data Data Dosen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Dosen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: nikController,
              decoration: const InputDecoration(labelText: 'NIK'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nama_dosenController,
              decoration: const InputDecoration(labelText: 'Nama Dosen'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: kode_dosenController,
              decoration: const InputDecoration(labelText: 'Kode Dosen'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addDataDosen();
              },
              child: const Text('Tambah Data Dosen'),
            ),
          ],
        ),
      ),
    );
  }
}
