import 'package:flutter/material.dart';
import 'package:flutter_app/values.dart';
import 'package:flutter_app/models/Cuenta.dart';
import 'package:flutter_app/models/Mes.dart';

class Info extends StatefulWidget {
  const Info({ Key? key }) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String mes = Values().nombresMes[(DateTime.now().month)-1];
  Cuenta c = Values().cuentas[Values().seleccionado];

  bool HayDatos(){
    bool exists = c.Meses.where((v)=>v.NMes == mes).isNotEmpty;
    if(!exists){
      c.Meses.add(new Mes(mes));
      return false;
    }
    else{
      return true;
    }
  }

  void ChangeIngreso(double valor){
    c.Meses.where((v)=>v.NMes == mes).first.Ingreso = valor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: c.Meses.where((v)=>v.NMes == mes).isNotEmpty
          ?Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(c.Nombre),
              Text(c.Meses.where((v)=>v.NMes == mes).first.GetAhorros().toString()+"€")
            ],
          )
          :Text("Inicio de mes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: HayDatos()
          ?Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: Column(
                      children: [
                        Text("Ingresos"),
                        Text(c.Meses.where((v)=>v.NMes==mes).first.Ingreso.toString())
                      ],
                    ),
                  ),
                  InkWell(
                    child: Card(
                      child: Column(
                        children: [
                          Text("Gastos"),
                          Text(c.Meses.where((v)=>v.NMes==mes).first.GetGastos().toString())
                        ],
                      ),
                    ),
                    onTap: (){},
                  )
                ],
              )
            ],
          )
          :Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Icon(Icons.euro,size: 50,color:Colors.yellow),
              SizedBox(height: 80,),
              Text("¿Cuanto se ha ingresado en "+mes+"?"),
              SizedBox(height: 10,),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Ingreso para "+mes
                ),
                onChanged: (v){
                  ChangeIngreso(double.parse(v));
                },
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    Values().cuentas[Values().seleccionado] = c;
                  });
                },
                child: Text("Confirmar")
              )
            ]
          ),
        ),
      )
    );
  }
}