import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/pantallas/login/widgetTree.dart';
import 'package:cuentas_android/pattern/positions.dart';
import 'package:cuentas_android/themes/DarkTheme.dart';
import 'package:cuentas_android/themes/LightTheme.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  // 1. Initialize WidgetsFlutterBinding
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Access Firebase features (including cuentaDao)
  await cuentaDao().obtenerDatos();

  // 4. Run the app
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
      home: Scaffold(
          body:  Tree()
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
