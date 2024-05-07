// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

// Kelas utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Enkripsi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EnkripsiDemo(),
    );
  }
}

// Kelas untuk halaman aplikasi
class EnkripsiDemo extends StatefulWidget {
  const EnkripsiDemo({super.key});

  @override
  _EnkripsiDemoState createState() => _EnkripsiDemoState();
}

// State dari halaman aplikasi
class _EnkripsiDemoState extends State<EnkripsiDemo> {
  // Controller untuk input teks
  final TextEditingController _textController = TextEditingController();
  // Teks hasil enkripsi dan dekripsi
  String _encryptedText = '';
  String _decryptedText = '';

  // Fungsi untuk melakukan enkripsi teks menggunakan algoritma RC4
  String _encryptText(String text, String keyString) {
    List<int> keyBytes = utf8.encode(keyString);
    List<int> plainBytes = utf8.encode(text);
    List<int> cipherBytes = List<int>.from(plainBytes);

    int j = 0, tmp;
    for (int i = 0; i < cipherBytes.length; i++) {
      j = (j + keyBytes[i % keyBytes.length]) % cipherBytes.length;
      tmp = cipherBytes[i];
      cipherBytes[i] = cipherBytes[j];
      cipherBytes[j] = tmp;
    }

    return base64.encode(cipherBytes);
  }

  // Fungsi untuk melakukan dekripsi teks menggunakan algoritma RC4
  String _decryptText(String encryptedText, String keyString) {
    List<int> keyBytes = utf8.encode(keyString);
    List<int> cipherBytes = base64.decode(encryptedText);
    List<int> plainBytes = List<int>.from(cipherBytes);

    int j = 0, tmp;
    for (int i = 0; i < plainBytes.length; i++) {
      j = (j + keyBytes[i % keyBytes.length]) % plainBytes.length;
      tmp = plainBytes[i];
      plainBytes[i] = plainBytes[j];
      plainBytes[j] = tmp;
    }

    return utf8.decode(plainBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Enkripsi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Input teks
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Masukkan Teks untuk Dienskripsi',
              ),
            ),
            const SizedBox(height: 16.0),
            // Tombol untuk melakukan enkripsi dan dekripsi
            ElevatedButton(
              onPressed: () {
                setState(() {
                  const keyString = 'kunci_rahasia_saya'; // Kunci untuk enkripsi RC4
                  _encryptedText = _encryptText(_textController.text, keyString);
                  _decryptedText = _decryptText(_encryptedText, keyString);
                });
              },
              child: const Text('Enkripsi/Dekripsi'),
            ),
            const SizedBox(height: 16.0),
            // Teks hasil enkripsi dan dekripsi
            Text(
              'Teks Terenkripsi: $_encryptedText',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Teks Terdekripsi: $_decryptedText',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
