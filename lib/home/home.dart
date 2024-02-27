import 'package:flutter/material.dart';
import 'package:flutter_app/values.dart';
import 'package:flutter_app/widgets/ItemView.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: Values().cuentas.map<Widget>((cuenta)=>ItemCard(cuenta.Nombre,cuenta.GetTotal())).toList()
          ),
        ),
    );
  }
}