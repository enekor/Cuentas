import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget GastoView(
    void Function(String, double) OnSave,
    void Function(String, double) OnDelete,
    void Function(String, double) OnRestore,
    String nombre,
    double valor,
    int contador) {

  RxBool tocado = false.obs;
  RxBool borrado = false.obs;
  
  return Obx(()=>tocado.value
    ? Padding(
    padding: const EdgeInsets.all(8),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex:3,
            child: Text(nombre)
          ),
          Expanded(
            flex:5,
            child: TextField(
                keyboardType: TextInputType.number,
                decoration:const InputDecoration(labelText: "Monto"),
                onChanged: (v) => valor = double.parse(v)),
          ),
          Expanded(
            flex:1,
            child: IconButton(
                icon: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                onPressed: () {
                  tocado.value = false;
                  OnSave(nombre, valor);
                }),
          ),
          Expanded(
            flex:1,
            child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: (){
                  tocado.value = false;
                  borrado.value = true;
                  OnDelete(nombre, valor);
                }),
              ),
            ],
          ),
        ),
      )
    : Padding(
      padding: const EdgeInsets.only(top:10.0,bottom: 10),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: borrado.value == false
          ?[
            Text(nombre), 
            TextButton(
              onPressed: ()=>tocado.value = true, 
              child: Text("${valor.toStringAsFixed(2)}€")
            )
          ]
          :[
            Text(
              nombre,
              style:const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.red
              )
            ),
            IconButton(
              icon: const Icon(Icons.restore),
              onPressed: (){
                borrado.value = false;
                OnRestore(nombre,valor);
              },
              color: Colors.blue,
            )
          ],
        ),
      ),
    )
  );
}
