import 'package:flutter/material.dart';
import 'info.dart';
import 'package:cuentas_android/values.dart';
import 'package:get/get.dart';
import 'package:cuentas_android/widgets/GastoView.dart';

class Extras extends StatefulWidget {
  const Extras({ Key? key }) : super(key: key);

  @override
  _ExtrasState createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  Rx<Map<String,double>> extras = new Rx<Map<String,double>>(Values().cuentas[Values().seleccionado].Meses.where((v)=>v.NMes == Values().GetMes()).first.Extras);
  String nuevoNombre = "";
  double nuevoValor = 0;
  RxBool nuevo = false.obs;

  @override
  Widget build(BuildContext context) {

    List<Widget> GetExtras(){
      List<Widget> ret = [];

      extras.value.forEach((nombre,valor) {
        
        ret.add(GastoView(
          (nombre,valor)=>extras.value[nombre]=valor,
          (nombre,valor)=>extras.value.removeWhere((n,v)=>n==nombre && v==valor),
          (_){},
          nombre,
          valor,
          1
        ));
      });

      ret.add(nuevo.value
        ?Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex:2,
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: ()=>extras.value[nuevoNombre] = nuevoValor,
              ),
            ),
            Expanded(
              flex:4,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Nombre"
                ),
                onChanged: (v){
                  nuevoNombre = v;
                },
              ),
            ),
            Expanded(
              flex:4,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Monto"
                ),
                onChanged: (v){
                  nuevoValor = double.parse(v);
                },
              ),
            )
          ],
        )
        :SizedBox());
      return ret;
    }

    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder:(context)=>Info())
        );

        return true;
      },
      child: Obx(()=>Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: ()=>nuevo.value = !nuevo.value,
          ),
          body: Padding(
            padding: EdgeInsets.all(35),
            child: Column(
              children: GetExtras()
            )
          )
        ),
      ),
    );
  }
}