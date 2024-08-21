import 'package:crud_sqflite_app/pages/add/add.dart';
import 'package:crud_sqflite_app/pages/home/home.dart';
import 'package:crud_sqflite_app/route/app_route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App',
      initialRoute: AppRoute.home,
      theme: ThemeData(
          primaryColor: Colors.blue.shade400, primaryColorLight: Colors.white),
      routes: {
        AppRoute.home: (context) => const HomePage(),
        AppRoute.add: (context) => const AddDataForm(),
      },
    );
  }
}
