import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tugas_mahasiswa/mahasiswa/mahasiswa.dart';
import 'package:tugas_mahasiswa/dosen/dosen.dart';
import 'package:tugas_mahasiswa/matakuliah/matkul.dart';
import 'package:tugas_mahasiswa/ruangan/ruangan.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  // Halaman-halaman yang akan ditampilkan
  final List<Widget> _pages = [
    HomePage(),
    MyApp(),
    Dosen(),
    Matkul(),
    Ruangan(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universitas Logistik dan Bisnis Internasional'),
        backgroundColor: Colors.red,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color.fromARGB(255, 4, 4, 4),
        selectedItemColor: Colors.red,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 122, 150, 69),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 114, 208, 239),
            icon: Icon(Icons.person),
            label: 'Data Mahasiswa',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 239, 156, 114),
            icon: Icon(Icons.people),
            label: 'Data Dosen',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 239, 156, 114),
            icon: Icon(Icons.school_sharp),
            label: 'Data Matkul',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 239, 156, 114),
            icon: Icon(Icons.room_preferences),
            label: 'Data Ruangan',
          ),
        ],
      ),
    );
  }
}

// Kelas AboutPage yang baru ditambahkan


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ulbi.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tempatkan logo atau elemen lain di sini
              ],
            ),
          ),
          Positioned(
            top: 160, // Sesuaikan dengan posisi vertikal yang diinginkan
            left: 30, // Sesuaikan dengan posisi vertikal yang diinginkan
            child: Center(
              child: Text(
                'SELAMAT DATANG DI KAMPUS ULBI!!!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BottomNav(),
  ));
}
