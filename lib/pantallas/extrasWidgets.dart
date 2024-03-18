import 'package:cuentas_android/widgets/GastoView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<Widget> GetExtras({required RxList extras, required Function(String,double) onChangeExtra,required Function(String,double) onDeleteExtra}) {
      List<Widget> ret = [];

      if (extras.isNotEmpty) {
        for (var gasto in extras) {
          ret.add(
            Card(
              child:GastoView(
                onChangeExtra,
                onDeleteExtra,
                gasto.nombre,
                gasto.valor,
                1
              )
            )
          );
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
  String _nombrenuevo = "";
  double _valorNuevo = 0;
  return Row(
    mainAxisAlignment:
        MainAxisAlignment.spaceAround,
    children: [
      Expanded(
        child: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => onCreateExtra,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: TextField(
          decoration: const InputDecoration(
              labelText: "Nombre"),
          onChanged: (v) {
            _nombrenuevo = v;
          },
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
          onChanged: (v) {
            _valorNuevo = double.parse(v);
          },
        ),
      )
    ],
  );
}