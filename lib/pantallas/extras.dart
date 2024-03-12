import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/models/Gasto.dart';
import 'package:cuentas_android/pattern/pattern.dart';
import 'package:cuentas_android/pattern/positions.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/values.dart';
import 'package:get/get.dart';
import 'package:cuentas_android/widgets/GastoView.dart';

class Extras extends StatefulWidget {
  Cuenta cuenta;
  Extras({Key? key,required this.cuenta}) : super(key: key);

  @override
  _ExtrasState createState() => _ExtrasState(cuenta);
}

class _ExtrasState extends State<Extras> {

  late Cuenta c;
  List<Gasto> extras = [];
  String nuevoNombre = "";
  double nuevoValor = 0;
  RxBool nuevo = false.obs;

  _ExtrasState(this.c);

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
     c.Meses.where((element) => element.NMes == Values().GetMes() && element.Anno == Values().anno.value).first.Extras = extras;
  }

  @override
  void initState() {
    super.initState();
    extras = c.Meses.where((v) => v.NMes == Values().GetMes() && v.Anno == Values().anno.value).first.Extras;
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
        positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
        saveExtras();
        await cuentaDao().almacenarDatos(c);
        Values().cuentaRet = c;
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
