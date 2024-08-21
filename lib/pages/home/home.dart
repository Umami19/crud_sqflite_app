import 'dart:async';
import 'dart:convert';

import 'package:crud_sqflite_app/model/mahasiswa.dart';
import 'package:crud_sqflite_app/pages/edit/edit.dart';
import 'package:crud_sqflite_app/pages/view/view.dart';
import 'package:crud_sqflite_app/route/app_route.dart';
import 'package:crud_sqflite_app/services/db_uri.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Mahasiswa>> mahasiswas;
  List<Mahasiswa> _filteredMahasiswas = [];
  final TextEditingController _searchController = TextEditingController();

  Future<List<Mahasiswa>> getMahasiswaList() async {
    final response = await http.get(Uri.parse('${DbUri.wifiUri}/list.php'));
    var items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Mahasiswa> mahasiswa = items.map<Mahasiswa>((map) {
      return Mahasiswa.fromJson(map);
    }).toList();

    return mahasiswa;
  }

  @override
  void initState() {
    super.initState();
    mahasiswas = getMahasiswaList();
    mahasiswas.then((data) {
      setState(() {
        _filteredMahasiswas = data;
      });
    });
    _searchController.addListener(_filterMahasiswas);
  }

  void _filterMahasiswas() {
    setState(() {
      if (_searchController.text.isEmpty) {
        mahasiswas.then((data) {
          _filteredMahasiswas = data;
        });
      } else {
        mahasiswas.then((data) {
          _filteredMahasiswas = data.where((mahasiswa) {
            return mahasiswa.nama
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
          }).toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pendataan Mahasiswa",
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Josefin',
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: FutureBuilder<List<Mahasiswa>>(
            future: mahasiswas,
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _filteredMahasiswas.length,
                  itemBuilder: (context, index) {
                    var data = _filteredMahasiswas[index];
                    return Card(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                '${DbUri.wifiUri}/images/${data.image}',
                                height: 100,
                                width: 130,
                                fit: BoxFit.cover,
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(data.nama.split(' ')[0],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Josefin')),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.list),
                                  iconSize: 24,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: ((context) {
                                      return ViewPage(mahasiswa: data);
                                    })));
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    iconSize: 24,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return EditDataForm(mahasiswa: data);
                                        },
                                      ));
                                    }),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  });
            }),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.add);
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
        child: const Icon(Icons.add),
      ),
    );
  }
}
