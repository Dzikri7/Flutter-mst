import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const Ruangan());

class Ruangan extends StatelessWidget {
  const Ruangan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Pemrog ULBI',
      initialRoute: '/',
      routes: {
        '/': (context) => const DataRuanganListScreen(),
        '/add': (context) => const AddDataRuanganScreen(),
      },
    );
  }
}

class DataRuangan {
  final String kode_ruangan;
  final String nama_ruangan;

  DataRuangan({
    required this.kode_ruangan,
    required this.nama_ruangan,
  });

  factory DataRuangan.fromJson(Map<String, dynamic> json) {
    return DataRuangan(
      kode_ruangan: json['kode_ruangan'],
      nama_ruangan: json['nama_ruangan'],
    );
  }
}

class DataRuanganListScreen extends StatefulWidget {
  const DataRuanganListScreen({Key? key}) : super(key: key);

  @override
  _DataRuanganListScreenState createState() => _DataRuanganListScreenState();
}

class _DataRuanganListScreenState extends State<DataRuanganListScreen> {
  List<DataRuangan> DataRuangans = [];

  Future<void> fetchDataRuangans() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:80/ulbi2024/ruangan.php'));

      if (response.statusCode == 200) {
        setState(() {
          Iterable list = json.decode(response.body);
          DataRuangans = list.map((model) => DataRuangan.fromJson(model)).toList();
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataRuangans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Ruangan"),
      ),
      body: ListView.builder(
        itemCount: DataRuangans.length,
        itemBuilder: (context, index) {
          final DataRuangan = DataRuangans[index];
          return ListTile(
            title: Text(DataRuangan.nama_ruangan),
            subtitle: Text("Kode Ruangan: ${DataRuangan.kode_ruangan}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((value) {
            if (value == true) {
              fetchDataRuangans();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddDataRuanganScreen extends StatefulWidget {
  const AddDataRuanganScreen({Key? key}) : super(key: key);

  @override
  _AddDataRuanganScreenState createState() => _AddDataRuanganScreenState();
}

class _AddDataRuanganScreenState extends State<AddDataRuanganScreen> {
  final TextEditingController kode_ruanganController = TextEditingController();
  final TextEditingController nama_ruanganController = TextEditingController();

  Future<void> addDataRuangan() async {
    final String kode_ruangan = kode_ruanganController.text;
    final String nama_ruangan = nama_ruanganController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:80/ulbi2024/ruangan.php'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'kode_ruangan': kode_ruangan, 'nama_ruangan': nama_ruangan}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Data Data Ruangan Berhasil di Tambah");
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: "Gagal menambah Data Data Ruangan");
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding data: $error');
      Fluttertoast.showToast(msg: "Terjadi kesalahan saat menambah Data Data Ruangan");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Ruangan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: kode_ruanganController,
              decoration: const InputDecoration(labelText: 'Kode Ruangan'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nama_ruanganController,
              decoration: const InputDecoration(labelText: 'Nama Ruangan'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addDataRuangan();
              },
              child: const Text('Tambah Data Ruangan'),
            ),
          ],
        ),
      ),
    );
  }
}
