import 'package:flutter/material.dart';
import 'database.dart';

class AddDriverPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nopolController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tukang Ojek'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nopolController,
              decoration: InputDecoration(labelText: 'Nomor Polisi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                String nopol = _nopolController.text;

                await DatabaseHelper().insertTukangOjek(name, nopol);

                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}