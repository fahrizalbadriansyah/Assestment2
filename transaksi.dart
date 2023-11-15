import 'package:flutter/material.dart';
import 'database.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  int? driverId;
  TextEditingController _amountController = TextEditingController();

  List<DropdownMenuItem<int>>? _dropdownItems;

  @override
  void initState() {
    super.initState();
    _loadDriverData();
  }

  Future<void> _loadDriverData() async {
    List<Map<String, dynamic>> drivers = await _dbHelper.getTukangOjekStats(sortField: 'nama');
    setState(() {
      _dropdownItems = drivers.map((driver) {
        return DropdownMenuItem<int>(
          value: driver['id'],
          child: Text(driver['nama']),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<int>(
              value: driverId,
              onChanged: (int? newValue) {
                setState(() {
                  driverId = newValue;
                });
              },
              items: _dropdownItems,
              decoration: InputDecoration(labelText: 'Pilih Tukang Ojek'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Jumlah Harga'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (driverId != null) {
                  int amount = int.tryParse(_amountController.text) ?? 0;
                  await _dbHelper.insertTransaksi(driverId!, amount);
                  Navigator.pop(context); // Kembali ke halaman sebelumnya setelah menambahkan transaksi
                }
              },
              child: Text('Tambah Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}