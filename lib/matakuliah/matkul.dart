import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const Matkul());

class Matkul extends StatelessWidget {
  const Matkul({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Pemrog ULBI',
      initialRoute: '/',
      routes: {
        '/': (context) => const DataMatkulListScreen(),
        '/add': (context) => const AddDataMatkulScreen(),
      },
    );
  }
}

class DataMatkul {
  final String nama_matkul;
  final String kode_matkul;
  final String jumlah_sks;

  DataMatkul({
    required this.nama_matkul,
    required this.kode_matkul,
    required this.jumlah_sks,
  });

  factory DataMatkul.fromJson(Map<String, dynamic> json) {
    return DataMatkul(
      nama_matkul: json['nama_matkul'],
      kode_matkul: json['kode_matkul'],
      jumlah_sks: json['jumlah_sks'],
    );
  }
}

class DataMatkulListScreen extends StatefulWidget {
  const DataMatkulListScreen({Key? key}) : super(key: key);

  @override
  _DataMatkulListScreenState createState() => _DataMatkulListScreenState();
}

class _DataMatkulListScreenState extends State<DataMatkulListScreen> {
  List<DataMatkul> DataMatkuls = [];

  Future<void> fetchDataMatkuls() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:80/ulbi2024/matkul.php'));

      if (response.statusCode == 200) {
        setState(() {
          Iterable list = json.decode(response.body);
          DataMatkuls = list.map((model) => DataMatkul.fromJson(model)).toList();
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataMatkuls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Matkul"),
      ),
      body: ListView.builder(
        itemCount: DataMatkuls.length,
        itemBuilder: (context, index) {
          final DataMatkul = DataMatkuls[index];
          return ListTile(
            title: Text(DataMatkul.kode_matkul),
            subtitle: Text("Jumlah SKS: ${DataMatkul.jumlah_sks}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((value) {
            if (value == true) {
              fetchDataMatkuls();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddDataMatkulScreen extends StatefulWidget {
  const AddDataMatkulScreen({Key? key}) : super(key: key);

  @override
  _AddDataMatkulScreenState createState() => _AddDataMatkulScreenState();
}

class _AddDataMatkulScreenState extends State<AddDataMatkulScreen> {
  final TextEditingController nama_matkulController = TextEditingController();
  final TextEditingController kode_matkulController = TextEditingController();
  final TextEditingController jumlah_sksController = TextEditingController();

  Future<void> addDataMatkul() async {
    final String nama_matkul = nama_matkulController.text;
    final String kode_matkul = kode_matkulController.text;
    final String jumlah_sks = jumlah_sksController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:80/ulbi2024/matkul.php'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'nama_matkul': nama_matkul, 'kode_matkul': kode_matkul, 'jumlah_sks': jumlah_sks}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Data Data Matkul Berhasil di Tambah");
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: "Gagal menambah Data Data Matkul");
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding data: $error');
      Fluttertoast.showToast(msg: "Terjadi kesalahan saat menambah Data Data Matkul");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Matkul'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: nama_matkulController,
              decoration: const InputDecoration(labelText: 'Nama Matkul'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: kode_matkulController,
              decoration: const InputDecoration(labelText: 'Kode Matkul'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: jumlah_sksController,
              decoration: const InputDecoration(labelText: 'Jumlah SKS'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addDataMatkul();
              },
              child: const Text('Tambah DataMatkul'),
            ),
          ],
        ),
      ),
    );
  }
}
