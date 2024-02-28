import 'package:flutter/material.dart';
import 'package:flutter_app/values.dart';
import 'package:flutter_app/widgets/ItemView.dart';
import 'package:flutter_app/pantallas/info.dart';

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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: Values().cuentas.map<Widget>(
                (cuenta) => InkWell(
                  onTap:(){
                    Values().seleccionar(cuenta.id);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder:(context)=>Info())
                    );
                  },
                  child: ItemCard(cuenta.Nombre,cuenta.GetTotal())
                )
              ).toList()
            ),
          ),
        ),
    );
  }
}