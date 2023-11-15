import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';
import 'tukangojek.dart';
import 'transaksi.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String _sortField = 'nama';

  @override
  void initState() {
    super.initState();
    _loadSortField();
  }

  Future<void> _loadSortField() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sortField = prefs.getString('sortField') ?? 'nama';
    });
  }

  Future<void> _saveSortField(String field) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sortField', field);
  }

  void _changeSortField(String field) {
    setState(() {
      _sortField = field;
    });
    _saveSortField(field);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OPANGATIMIN - Aplikasi Ojek'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.getTukangOjekStats(sortField: _sortField),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _changeSortField('nama'),
                      child: Text('Urutkan Nama'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _changeSortField('orderCount'),
                      child: Text('Urutkan Jumlah Order'),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index]['nama']),
                        subtitle: Text('Order: ${snapshot.data![index]['orderCount']} | Omzet: ${snapshot.data![index]['omzet']}'),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddDriverPage()));
            },
            child: Icon(Icons.person_add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionPage()));
            },
            child: Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
    );
  }
}