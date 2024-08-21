import 'package:crud_sqflite_app/model/mahasiswa.dart';
import 'package:crud_sqflite_app/route/app_route.dart';
import 'package:crud_sqflite_app/services/db_uri.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewPage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  const ViewPage({super.key, required this.mahasiswa});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  void deleteMahasiswa(context) async {
    final uri = Uri.parse("${DbUri.wifiUri}/delete.php");
    var postRequest = http.MultipartRequest('POST', uri);
    var getRequest = http.MultipartRequest('GET', uri);
    postRequest.fields['id'] = widget.mahasiswa.id.toString();
    await getRequest.send();
    await postRequest.send();
    // Navigator.pop(context);
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoute.home, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).primaryColorLight,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Mahasiswa',
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Josefin',
                                fontWeight: FontWeight.bold)),
                        content: const Text(
                            'Are you sure want to delete this data?',
                            style:
                                TextStyle(fontSize: 16, fontFamily: 'Josefin')),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      fontFamily: 'Josefin', fontSize: 14))),
                          TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Delete Data is completed')),
                                );
                                deleteMahasiswa(context);
                              },
                              child: const Text('Confirm',
                                  style: TextStyle(
                                      fontFamily: 'Josefin', fontSize: 14))),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.delete),
              iconSize: 24,
            ),
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              iconSize: 24),
        ),
        body: ListView(shrinkWrap: true, children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Image.network(
                  '${DbUri.wifiUri}/images/${widget.mahasiswa.image}',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                    )
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  alignment: const Alignment(-1, 0),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.mahasiswa.nama,
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'Josefin',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      widget.mahasiswa.nim,
                                      style: const TextStyle(
                                          fontSize: 20, fontFamily: 'Josefin'),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Row(
                                  children: [
                                    Text(
                                      'Deskripsi:',
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: 'Josefin'),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: const Alignment(-1, 0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.black),
                                          bottom:
                                              BorderSide(color: Colors.black),
                                          left: BorderSide(color: Colors.black),
                                          right:
                                              BorderSide(color: Colors.black))),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.mahasiswa.description,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Josefin'),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}
