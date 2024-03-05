import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget GastoView(
    void Function(String, double) OnSave,
    void Function(String, double) OnDelete,
    void OnSeleccionar(int),
    String nombre,
    double valor,
    int contador) {
      RxBool tocado = false.obs;
      RxBool borrado = false.obs;
  return Obx(()=>tocado.value
      ? Padding(
        padding: const EdgeInsets.only(top:8,bottom: 8),
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
                    decoration:
                        InputDecoration(labelText: "Monto"),
                    onChanged: (v) => valor = double.parse(v)),
              ),
              Expanded(
                flex:1,
                child: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      OnSave(nombre, valor);
                      tocado.value = false;
                    }),
              ),
              Expanded(
                flex:1,
                child: IconButton(
                    icon: Icon(Icons.cancel, color: Colors.red),
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
      : GestureDetector(
        onTap: ()=>tocado.value = true,
        child: Padding(
          padding: const EdgeInsets.only(top:10.0,bottom: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: borrado == false
              ?[
                Text(nombre), 
                Text(valor.toString() + "€")
              ]
              :[
                Text(
                  nombre,
                  style:TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.red
                  )
                ),
                IconButton(
                  icon: Icon(Icons.restore),
                  onPressed: (){
                    OnSave(nombre,valor);
                    borrado.value = false;
                  },
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      )
    );
}
