import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget GastoView(
    void Function(String, double) OnSave,
    void Function(String, double) OnDelete,
    void OnSeleccionar(int),
    String nombre,
    double valor,
    Rx<int> seleccionado,
    int contador) {
  return seleccionado.value == contador
      ? Obx(
          () => InkWell(
              onTap: () => OnSeleccionar(contador),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      onPressed: () => OnSave(nombre, valor)),
                  IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => OnDelete(nombre, valor)),
                  TextField(
                      decoration: InputDecoration(labelText: "Nombre de gasto"),
                      onChanged: (v) => nombre = v),
                  TextField(
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(labelText: "Monto de " + nombre),
                      onChanged: (v) => valor = double.parse(v))
                ],
              )),
        )
      : Row(
          children: [Text(nombre), Text(valor.toString() + "€")],
        );
}
