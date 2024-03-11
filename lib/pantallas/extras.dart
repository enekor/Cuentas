import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/models/Gasto.dart';
import 'package:cuentas_android/pattern/pattern.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/values.dart';
import 'package:get/get.dart';
import 'package:cuentas_android/widgets/GastoView.dart';

class Extras extends StatefulWidget {
  const Extras({Key? key}) : super(key: key);

  @override
  _ExtrasState createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  List<Gasto> extras = Values().cuentas[Values().seleccionado].Meses.where((v) => v.NMes == Values().GetMes()).first.Extras;
  String nuevoNombre = "";
  double nuevoValor = 0;
  RxBool nuevo = false.obs;

  void SaveExtra(String nombre, double valor) {
    if (extras.where((v) => v.nombre == nuevoNombre).isNotEmpty) {
      extras.where((v) => v.nombre == nuevoNombre).first.valor = valor;
    } else {
      extras.add(Gasto(nombre: nombre, valor: valor));
    }

    saveExtras();
    nuevo.value = false;
  }

  void saveExtras() {
     Values().cuentas[Values().seleccionado].Meses.where((element) => element.NMes == Values().GetMes()).first.Extras = extras;
  }

  @override
  void initState() {
    super.initState();
    cuentaDao().obtenerDatos();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> GetExtras() {
      List<Widget> ret = [];

      if (extras.isNotEmpty) {
        extras.forEach((gasto) {
          ret.add(
            Card(

              child:GastoView(
              (nombre, valor) => setState(() {
                    SaveExtra(nombre, valor);
                    }),
              (nombre, valor) => extras
                  .removeWhere((n) => n.nombre == nombre && n.valor == valor),
              (_) {},
              gasto.nombre,
              gasto.valor,
              1))
          );
        });
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

    return PopScope(
      onPopInvoked: (_) async {
        saveExtras();
        await cuentaDao().almacenarDatos(Values().cuentas[Values().seleccionado]);
      },
      child: Obx(
        () => Scaffold(
            resizeToAvoidBottomInset: true,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => nuevo.value = !nuevo.value,
            ),
            body: CustomPaint(
              painter: MyPattern(context),
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(children: GetExtras()),
                        nuevo.value
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(Icons.check),
                                      onPressed: () =>
                                          SaveExtra(nuevoNombre, nuevoValor),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                          labelText: "Nombre"),
                                      onChanged: (v) {
                                        nuevoNombre = v;
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
                                        nuevoValor = double.parse(v);
                                      },
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox()
                      ],
                    ),
                  )),
            )),
      ),
    );
  }
}
