import 'package:flutter/material.dart';
import 'package:cuentas_android/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App!!',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 15),
          bodyLarge: TextStyle(fontSize: 20),
          bodySmall: TextStyle(fontSize: 12),
        )
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 15),
          bodyLarge: TextStyle(fontSize: 20),
          bodySmall: TextStyle(fontSize: 12),
        )
      ),
      home:  const Scaffold(
        body: Home()
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

