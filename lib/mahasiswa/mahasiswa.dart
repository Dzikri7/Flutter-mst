import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Pemrog ULBI',
      initialRoute: '/',
      routes: {
        '/': (context) => const MahasiswaListScreen(),
        '/add': (context) => const AddMahasiswaScreen(),
      },
    );
  }
}

class Mahasiswa {
  final String npm;
  final String nama_lengkap;
  final String alamat;

  Mahasiswa({
    required this.npm,
    required this.nama_lengkap,
    required this.alamat,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      npm: json['npm'],
      nama_lengkap: json['nama_lengkap'],
      alamat: json['alamat'],
    );
  }
}

class MahasiswaListScreen extends StatefulWidget {
  const MahasiswaListScreen({Key? key}) : super(key: key);

  @override
  _MahasiswaListScreenState createState() => _MahasiswaListScreenState();
}

class _MahasiswaListScreenState extends State<MahasiswaListScreen> {
  List<Mahasiswa> mahasiswas = [];

  Future<void> fetchMahasiswas() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:80/ulbi2024/mahasiswa.php'));

      if (response.statusCode == 200) {
        setState(() {
          Iterable list = json.decode(response.body);
          mahasiswas = list.map((model) => Mahasiswa.fromJson(model)).toList();
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMahasiswas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Mahasiswa"),
      ),
      body: ListView.builder(
        itemCount: mahasiswas.length,
        itemBuilder: (context, index) {
          final mahasiswa = mahasiswas[index];
          return ListTile(
            title: Text(mahasiswa.nama_lengkap),
            subtitle: Text("Alamat: ${mahasiswa.alamat}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((value) {
            if (value == true) {
              fetchMahasiswas();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddMahasiswaScreen extends StatefulWidget {
  const AddMahasiswaScreen({Key? key}) : super(key: key);

  @override
  _AddMahasiswaScreenState createState() => _AddMahasiswaScreenState();
}

class _AddMahasiswaScreenState extends State<AddMahasiswaScreen> {
  final TextEditingController npmController = TextEditingController();
  final TextEditingController nama_lengkapController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  Future<void> addMahasiswa() async {
    final String npm = npmController.text;
    final String nama_lengkap = nama_lengkapController.text;
    final String alamat = alamatController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:80/ulbi2024/mahasiswa.php'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'npm': npm, 'nama_lengkap': nama_lengkap, 'alamat': alamat}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Data Mahasiswa Berhasil di Tambah");
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: "Gagal menambah Data Mahasiswa");
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding data: $error');
      Fluttertoast.showToast(msg: "Terjadi kesalahan saat menambah Data Mahasiswa");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: npmController,
              decoration: const InputDecoration(labelText: 'N P M'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nama_lengkapController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addMahasiswa();
              },
              child: const Text('Tambah Mahasiswa'),
            ),
          ],
        ),
      ),
    );
  }
}
