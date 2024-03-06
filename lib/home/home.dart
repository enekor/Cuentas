import 'package:flutter/material.dart';
import 'package:cuentas_android/values.dart';
import 'package:cuentas_android/widgets/ItemView.dart';
import 'package:cuentas_android/pantallas/info.dart';
import 'package:cuentas_android/pattern/pattern.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:true,
      body: 
        CustomPaint(
          painter: MyPattern(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: Values().cuentas.map<Widget>(
                  (cuenta) => GestureDetector(
                    onTap:(){
                      Values().seleccionar(cuenta.id);
                      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>const Info()));
                    },
                    child: ItemCard(cuenta.Nombre,cuenta.GetTotal())
                  )
                ).toList()
              ),
            ),
          ),
        ),
    );
  }
}