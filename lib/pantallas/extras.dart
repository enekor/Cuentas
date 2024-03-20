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
  RxInt seleccionado = (-1).obs;

  String nuevoNombre = "";
  double nuevoValor = 0;
  RxList<Gasto> _toDelete = RxList<Gasto>([]);

  void _createExtra(String nombre, double valor){
    extras.value.add(Gasto(nombre: nombre, valor: valor));
    nuevo.value = false;
  }
  void _saveExtra(String nombre, double valor) {
      extras.value.where((v) => v.nombre == nombre).first.valor = valor;
  }

  void _deleteExtra(String nombre, double valor){
    _toDelete.value.add(Gasto(nombre: nombre, valor: valor));
  }

  void _restoreExtra(String nombre, double valor){
    _toDelete.value.removeWhere((element) => element.nombre == nombre && element.valor == valor);
  }

  void _deleteDefinitively(){
    for(Gasto g in _toDelete.value){
      extras.value.remove(g);
    }
  }

  void _pop(BuildContext context) {
    _deleteDefinitively();
    c.value.Meses.where((element) => element.Anno == Values().anno.value && element.NMes == Values().GetMes()).first.Extras = extras.value;
    positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
    cuentaDao().almacenarDatos(c.value);
    Values().cuentaRet = c.value;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => _pop(context),
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
                            onChangeExtra: _saveExtra,
                            onDeleteExtra: _deleteExtra,
                            onRestore: _restoreExtra,
                            onSelect: (v)=>seleccionado.value = v,
                            deleted: _toDelete,
                            seleccionado: seleccionado,
                            theme: Theme.of(context)
                          )
                        ),
                        nuevo.value
                          ? ew.crearNuevo(onCreateExtra: _createExtra)
                          : const SizedBox()
                      ],
                    ),
                  )),
            )),
      ),
    );
  }
}
