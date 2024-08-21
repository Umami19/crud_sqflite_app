import 'package:crud_sqflite_app/model/mahasiswa.dart';
import 'package:crud_sqflite_app/route/app_route.dart';
import 'package:crud_sqflite_app/services/db_uri.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditDataForm extends StatefulWidget {
  final Mahasiswa mahasiswa;

  const EditDataForm({super.key, required this.mahasiswa});

  @override
  State<EditDataForm> createState() => _EditDataFormState();
}

class _EditDataFormState extends State<EditDataForm> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _nimController;
  late TextEditingController _descriptionController;

  Future _updateMahasiswa() async {
    final uri = Uri.parse("${DbUri.wifiUri}/update.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['nama'] = _nameController.text;
    request.fields['nim'] = _nimController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['createdAt'] =
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    request.fields['id'] = widget.mahasiswa.id.toString();
    await request.send();
  }

  void _onSubmit(context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Data is completed')),
    );

    await _updateMahasiswa();

    // Remove all existing routes until the Home.dart, then rebuild Home.
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoute.home, (Route<dynamic> route) => false);
  }

  String? get _errorNameText {
    final name = _nameController.value.text;

    if (name.isEmpty) {
      return 'Please fill the name field';
    }

    return null;
  }

  String? get _errorDescriptionText {
    final description = _descriptionController.value.text;

    if (description.isEmpty) {
      return 'Please fill the description field';
    }

    return null;
  }

  String? get _errorNimText {
    final nim = _nimController.value.text;

    final RegExp nimRegExp = RegExp(r'[0-9]{13}');

    if (nimRegExp.hasMatch(nim)) {
      return null;
    } else {
      return 'Please fill the valid NIM and length must 13';
    }
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.mahasiswa.nama);
    _nimController = TextEditingController(text: widget.mahasiswa.nim);
    _descriptionController =
        TextEditingController(text: widget.mahasiswa.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Mahasiswa',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Josefin')),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            iconSize: 24),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.6), width: 1)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: const Alignment(-1, 0),
                          child: const Text(
                            'Name',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontFamily: 'Josefin'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill the name field';
                              }

                              return null;
                            },
                            controller: _nameController,
                            decoration: InputDecoration(
                                errorText: _errorNameText,
                                errorStyle: const TextStyle(
                                    fontFamily: 'Josefin', fontSize: 14),
                                label: const Text('Type your name'),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                filled: true,
                                fillColor:
                                    const Color.fromRGBO(196, 193, 193, 0.6),
                                contentPadding: const EdgeInsets.only(
                                    top: 8, left: 12, bottom: 8, right: 12)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.6), width: 1)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: const Alignment(-1, 0),
                          child: const Text(
                            'NIM',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontFamily: 'Josefin'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: TextFormField(
                            validator: (value) {
                              final RegExp nimRegExp =
                                  RegExp(r'^[0-9]|1[0-3]$');

                              if (nimRegExp.hasMatch(value!)) {
                                return null;
                              } else {
                                return 'Please fill the valid NIM and length must 13';
                              }
                            },
                            controller: _nimController,
                            decoration: InputDecoration(
                                errorText: _errorNimText,
                                errorStyle: const TextStyle(
                                    fontFamily: 'Josefin', fontSize: 14),
                                label: const Text('Type your NIM price'),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                filled: true,
                                fillColor:
                                    const Color.fromRGBO(196, 193, 193, 0.6),
                                contentPadding: const EdgeInsets.only(
                                    top: 8, left: 12, bottom: 8, right: 12)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.6), width: 1)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: const Alignment(-1, 0),
                          child: const Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontFamily: 'Josefin'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill the description field';
                              }

                              return null;
                            },
                            controller: _descriptionController,
                            maxLines: 10,
                            decoration: InputDecoration(
                                label: const Text('Type your description'),
                                errorText: _errorDescriptionText,
                                errorStyle: const TextStyle(
                                    fontFamily: 'Josefin', fontSize: 14),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                filled: true,
                                fillColor:
                                    const Color.fromRGBO(196, 193, 193, 0.6),
                                contentPadding: const EdgeInsets.only(
                                    top: 8, left: 12, bottom: 8, right: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _onSubmit(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade700),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
