import 'package:cuentas_android/pattern/pattern.dart';
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
  
  Map<String,double> extras = Values().cuentas[Values().seleccionado].Meses.where((v)=>v.NMes == Values().GetMes()).first.Extras;
  String nuevoNombre = "";
  double nuevoValor = 0;
  RxBool nuevo = false.obs;

  void ChangeExtra(){
    setState(() {
      if(nuevoNombre != "" && nuevoValor >0){
        extras[nuevoNombre] = nuevoValor;
        nuevoNombre = "";
        nuevoValor = 0;
        nuevo.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> GetExtras(){
      List<Widget> ret = [];

      extras.forEach((nombre,valor) {
        
        ret.add(GastoView(
          (nombre,valor)=>extras[nombre]=valor,
          (nombre,valor)=>extras.removeWhere((n,v)=>n==nombre && v==valor),
          (_){},
          nombre,
          valor,
          1
        ));
      });

      return ret;
    }

    return PopScope(
      onPopInvoked: (_){
        debugPrint("hola extra");
      },
      child: Obx(()=>Scaffold(
          resizeToAvoidBottomInset:true,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: ()=>nuevo.value = !nuevo.value,
          ),
          body: CustomPaint(
            painter: MyPattern(),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Column(
                    children: GetExtras()
                  ),
                  nuevo.value
                  ?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: ()=>ChangeExtra(),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: "Nombre"
                          ),
                          onChanged: (v){
                            nuevoNombre = v;
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Monto"
                          ),
                          onChanged: (v){
                            nuevoValor = double.parse(v);
                          },
                        ),
                      )
                    ],
                  )
                  :const SizedBox()
                ],
              )
            ),
          )
        ),
      ),
    );
  }
}