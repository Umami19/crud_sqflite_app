import 'dart:io';
import 'dart:math';

import 'package:crud_sqflite_app/route/app_route.dart';
import 'package:crud_sqflite_app/services/db_uri.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddDataForm extends StatefulWidget {
  const AddDataForm({super.key});

  @override
  State<AddDataForm> createState() => _AddDataFormState();
}

class _AddDataFormState extends State<AddDataForm> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future _createMahasiswa() async {
    final uri = Uri.parse("${DbUri.wifiUri}/create.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['nama'] = _nameController.text;
    request.fields['nim'] = _nimController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['createdAt'] =
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    if (_image != null) {
      var pic = await http.MultipartFile.fromPath('image', _image!.path);
      request.files.add(pic);
    }
    return request.send();
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

  void _onSubmit(context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adding Data is completed')),
    );

    await _createMahasiswa();

    // Remove all existing routes until the Home.dart, then rebuild Home.
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoute.home, (Route<dynamic> route) => false);
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length,
      (_) => 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'
          .codeUnitAt(Random().nextInt(
              'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'
                  .length))));

  Future choiceImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Mengganti nama file gambar sebelum disimpan di _image
      File originalImage = File(pickedImage.path);
      File renamedImage = await _renameImage(originalImage);

      setState(() {
        _image = renamedImage;
      });
    } else {
      setState(() {
        _image = null;
      });
    }
  }

  Future<File> _renameImage(File originalImage) async {
    // Mendapatkan direktori dari file gambar asli
    final directory = originalImage.parent;

    // Membuat nama baru untuk file gambar
    final newFileName = "${getRandomString(10)}.jpg";

    // Membuat file baru dengan nama baru
    final newImage = originalImage.renameSync('${directory.path}/$newFileName');

    return newImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Mahasiswa',
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
                                label: const Text('Type your name',
                                    style: TextStyle(fontFamily: 'Josefin')),
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
                                label: const Text('Type your NIM price',
                                    style: TextStyle(fontFamily: 'Josefin')),
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
                                errorText: _errorDescriptionText,
                                label: const Text('Type your description',
                                    style: TextStyle(fontFamily: 'Josefin')),
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
                            'Image',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontFamily: 'Josefin'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: const Alignment(-1, 0),
                            child: ElevatedButton(
                              onPressed: () {
                                choiceImage();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey.shade700),
                              ),
                              child: const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(Icons.camera),
                                  ),
                                  Text(
                                    'Pick a image',
                                    style: TextStyle(
                                        fontSize: 24, fontFamily: 'Josefin'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _image != null
                            ? Image.file(
                                _image!,
                                width: 150,
                                height: 150,
                              )
                            : const Text('No Image Selected',
                                style: TextStyle(
                                    color: Colors.red, fontFamily: 'Josefin')),
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
                        style: TextStyle(fontSize: 24, fontFamily: 'Josefin'),
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
