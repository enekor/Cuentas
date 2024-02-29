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
  return Obx(()=>tocado.value
      ? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
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
            SizedBox(width:25),
            Expanded(
              child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => OnDelete(nombre, valor)),
            ),
            SizedBox(width:25),
            Expanded(
              child: Text(nombre)
            ),
            SizedBox(width:25),
            Expanded(
              child: TextField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: "Monto"),
                  onChanged: (v) => valor = double.parse(v)),
            ),
            SizedBox(width:25)
          ],
        ),
      )
      : GestureDetector(
        onTap: ()=>tocado.value = true,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(nombre), 
              Text(valor.toString() + "€")
            ],
          ),
        ),
      )
    );
}
