import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/models/Gasto.dart';
import 'package:cuentas_android/pattern/pattern.dart';
import 'package:cuentas_android/pattern/positions.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/values.dart';
import 'package:get/Get.dart';
import 'package:cuentas_android/pantallas/extrasWidgets.dart' as ew;

class Extras extends StatelessWidget {
  Extras({Key? key, required Cuenta cuenta}) : super(key: key){
    c = cuenta.obs;
    extras =  cuenta.Meses.where((v) => v.NMes == Values().GetMes() && v.Anno == Values().anno.value).first.Extras.obs;
  }

  late Rx<Cuenta> c;
  late RxList<Gasto> extras;
  RxBool nuevo = false.obs;

  String nuevoNombre = "";
  double nuevoValor = 0;

  void SaveExtra(String nombre, double valor) {
    if (extras.where((v) => v.nombre == nuevoNombre).isNotEmpty) {
      extras.where((v) => v.nombre == nuevoNombre).first.valor = valor;
    } else {
      extras.add(Gasto(nombre: nombre, valor: valor));
    }

    nuevo.value = false;
  }

  void DeleteExtra(String nombre, double valor){
    extras.value.removeWhere((element) => element.nombre == nombre && element.valor == valor);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) async {
        positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
        await cuentaDao().almacenarDatos(c.value);
        Values().cuentaRet = c.value;
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
                        Column(
                          children: ew.GetExtras(
                            extras: extras,
                            onChangeExtra: SaveExtra,
                            onDeleteExtra: DeleteExtra
                          )
                        ),
                        nuevo.value
                            ? ew.crearNuevo(onCreateExtra: SaveExtra)
                            : const SizedBox()
                      ],
                    ),
                  )),
            )),
      ),
    );
  }
}
