import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/themes/DarkTheme.dart';
import 'package:cuentas_android/themes/LightTheme.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  cuentaDao().almacenarDatos();
  cuentaDao().obtenerDatos();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App!!',
      theme: MyLightTheme,
      darkTheme: MyDarkTheme,
      home: const Scaffold(body: Home()),
      debugShowCheckedModeBanner: false,
    );
  }
}
