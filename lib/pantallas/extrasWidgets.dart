import 'package:cuentas_android/models/Gasto.dart';
import 'package:cuentas_android/widgets/GastoView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<Widget> GetExtras({required RxList extras, required Function(String,double) onChangeExtra,required Function(String,double) onDeleteExtra,required Function(int) onSelect, required ThemeData theme, required RxList<Gasto> deleted}) {
      List<Widget> ret = [];

      if (extras.isNotEmpty) {
        int contador = 1;
        for (var gasto in extras) {
          ret.add(
            gastoView(
              onChangeExtra,
              onDeleteExtra,
              onSelect,
              gasto.nombre,
              gasto.valor,
              contador,
              theme
            )
          );
          contador++;
        }
      } else {
        ret.add(Center(
          child: Column(
            children: [
              Image.asset(
                "lib/assets/images/gatook.png",
                height: 300,
                width: 300,
              ),
              const Text("Parece que no tienes extras, bien hecho")
            ],
          ),
        ));
      }

      return ret;
    }

Widget crearNuevo({required Function(String,double) onCreateExtra }){
  TextEditingController _nombreNuevo = TextEditingController();
  TextEditingController  _valorNuevo = TextEditingController();
  return Row(
    mainAxisAlignment:
        MainAxisAlignment.spaceAround,
    children: [
      Expanded(
        child: IconButton(
          icon: const Icon(Icons.check),
          onPressed:()=> onCreateExtra(_nombreNuevo.text,double.parse(_valorNuevo.text)),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: TextField(
          decoration: const InputDecoration(
              labelText: "Nombre"),
          controller: _nombreNuevo,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              labelText: "Monto"),
          controller: _valorNuevo,
        ),
      )
    ],
  );
}