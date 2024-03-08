import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/models/Gasto.dart';
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
  
  List<Gasto> extras = Values().cuentas[Values().seleccionado].Meses.where((v)=>v.NMes == Values().GetMes()).first.Extras;
  String nuevoNombre = "";
  double nuevoValor = 0;
  RxBool nuevo = false.obs;

  void SaveExtra(String nombre, double valor){
    if(extras.where((v)=>v.nombre == nuevoNombre).isNotEmpty){
      extras.where((v)=>v.nombre == nuevoNombre).first.valor = valor;
    }
    else{
      extras.add(Gasto(nombre: nombre, valor: valor));
    }
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> GetExtras(){
      List<Widget> ret = [];

      extras.forEach((gasto) {
        
        ret.add(GastoView(
          (nombre,valor)=>setState(() {
            SaveExtra(nombre, valor);
          }),
          (nombre,valor)=>extras.removeWhere((n)=>n.nombre==nombre && n.valor==valor),
          (_){},
          gasto.nombre,
          gasto.valor,
          1
        ));
      });

      return ret;
    }

    return PopScope(
      onPopInvoked: (_){
        cuentaDao().almacenarDatos();
      },
      child: Obx(()=>Scaffold(
          resizeToAvoidBottomInset:true,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: ()=>nuevo.value = !nuevo.value,
          ),
          body: CustomPaint(
            painter: MyPattern(context),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
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
                            onPressed: ()=>SaveExtra(nuevoNombre,nuevoValor),
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
                ),
              )
            ),
          )
        ),
      ),
    );
  }
}