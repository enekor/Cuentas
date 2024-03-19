import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/models/Gasto.dart';
import 'package:cuentas_android/pantallas/extras.dart';
import 'package:cuentas_android/pattern/pattern.dart';
import 'package:cuentas_android/pattern/positions.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/values.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/models/Mes.dart';
import 'package:get/Get.dart';
import 'package:cuentas_android/pantallas/infoWidgets.dart' as iw;

class Info extends StatelessWidget {
  Info({Key? key,required Cuenta cuenta}) : super(key: key){
    c = cuenta.obs;
  }

  late Rx<Cuenta> c;
  RxString _mes = Values().GetMes().obs;
  List<Gasto> _toDelete = [];
  RxBool _hasMesData = false.obs;

//metodos
  void _hasData() {
    bool exists = c.value.Meses.where((v) => v.NMes == _mes.value && v.Anno == Values().anno.value).isNotEmpty;
    _hasMesData.value = exists;
  }

  void _saveGasto(String nombre, double valor) {
    var gastos = c.value.Meses.where((v) => v.NMes == _mes.value && v.Anno == Values().anno.value).first.Gastos;
    if (gastos.where((v) => v.nombre == nombre).isNotEmpty) {
      gastos.where((v) => v.nombre == nombre).first.valor = valor;
    } else {
      gastos.add(Gasto(nombre: nombre, valor: valor));
    }
  }

  void _createMes(String mes, double valor){
    c.value.Meses.add(Mes.complete(Gastos: [], Extras: [], Ingreso: valor, NMes: mes, Anno: Values().anno.value));
    _hasData();
  }

  void _updateIngreso(String mes, double valor){
    c.value.Meses.where((element) => element.NMes == mes && element.Anno == Values().anno.value).first.Ingreso = valor;
  }

  void _deleteGasto(String nombre, double valor){
    _toDelete.add(Gasto(nombre: nombre, valor: valor));
  }

  void _restoreExtra(String nombre, double valor){
    _toDelete.removeWhere((element) => element.nombre == nombre && element.valor == valor);
  }

  void _deleteDefinitively(){
    if(_toDelete.isNotEmpty){
      for(Gasto g in _toDelete) {
        c.value.Meses.where((element) => element.Anno == Values().anno.value && element.NMes == _mes.value).first.Extras.remove(g);
      }
    }
  }

  void _pop(BuildContext context) {
    _deleteDefinitively();
    positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
    cuentaDao().almacenarDatos(c.value);
    Values().cuentaRet = c.value;
  }

  void _navigateExtras(BuildContext context) {
    cuentaDao().almacenarDatos(c.value);
    positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => Extras(cuenta: c.value,))).then((value) {
        c.value = Values().cuentaRet!;
        Navigator.pop(context);
      });
  }

//pantalla
  @override
  Widget build(BuildContext context) {
    _hasData();
    return PopScope(
        onPopInvoked: (_)=> _pop(context),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
              title: Obx(()=>c.value.Meses.where((v) => v.NMes == _mes.value && v.Anno == Values().anno.value).isNotEmpty
                  ? iw.appBarMesExists(
                    mes: _mes,
                    meses: c.value.Meses.obs,
                    nCuenta: c.value.Nombre,
                    total: c.value.GetTotal(Values().anno.value),
                    width: MediaQuery.of(context).size.width
                  )
                  : const Text("Inicio de mes"),
              )
            ),
            body: CustomPaint(
              painter: MyPattern(context),
              child: Obx(()=>Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: _hasMesData.value
                      ? iw.bodyMesExists(
                        context: context,
                        mes: _mes,
                        meses: c.value.Meses,
                        onExtraDelete: _deleteGasto,
                        onExtraSave: _saveGasto,
                        onExtras: () =>  _navigateExtras(context),
                        onIngresoChange: (ingreso)=>c.value.Meses.where((element) => element.NMes == _mes.value && element.Anno == Values().anno.value).first.Ingreso = double.parse(ingreso),
                        theme: Theme.of(context),
                        onRestore: _restoreExtra
                      )
                      : iw.bodyMesNotExists(
                        mes: _mes,
                        onCrearMes: _createMes,
                        onNuevoIngreso: _updateIngreso,
                        theme: Theme.of(context)
                      )
                  ),
                ),
              ),
            )
          ),
        );
  }
}
