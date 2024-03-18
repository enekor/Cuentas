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
  RxInt _gastoSeleccionado = (-1).obs;
  RxString _mes = Values().GetMes().obs;

  String _nombrenuevo = "Gasto";
  double valornuevo = 0;
  RxBool mostrarGastos = false.obs;
  RxBool ingresoEditar = false.obs;
  double nuevoIngreso = 0;

//metodos
  bool HayDatos() {
    bool exists = c.value.Meses.where((v) => v.NMes == _mes.value && v.Anno == Values().anno.value).isNotEmpty;
    return exists;
  }

  void GuardarGasto(String nombre, double valor) {
    var gastos = c.value.Meses.where((v) => v.NMes == _mes.value && v.Anno == Values().anno.value).first.Gastos;
    if (gastos.where((v) => v.nombre == nombre).isNotEmpty) {
      gastos.where((v) => v.nombre == nombre).first.valor = valor;
    } else {
      gastos.add(Gasto(nombre: nombre, valor: valor));
    }
  }

  void BorrarGasto(String nombre, double valor){
    c.value.Meses.where((element) => element.NMes == _mes.value && element.Anno == Values().anno).first.Gastos.removeWhere((element) => element.nombre == nombre && element.valor == valor);
  }

  void CrearMes(String mes, double valor){
    c.value.Meses.add(Mes.complete(Gastos: [], Extras: [], Ingreso: valor, NMes: mes, Anno: Values().anno.value));
  }

  void UpdateIngreso(String mes, double valor){
    c.value.Meses.where((element) => element.NMes == mes && element.Anno == Values().anno).first.Ingreso = valor;
  }

//pantalla
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
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0.0,
            title: c.value.Meses.where((v) => v.NMes == _mes.value && v.Anno == Values().anno.value).isNotEmpty
                ? iw.appBarMesExists(
                  mes: _mes,
                  meses: c.value.Meses.obs,
                  nCuenta: c.value.Nombre,
                  total: c.value.GetTotal(Values().anno.value),
                  width: MediaQuery.of(context).size.width
                )
                : const Text("Inicio de mes"),
          ),
          body: CustomPaint(
            painter: MyPattern(context),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: HayDatos()
                  ? iw.bodyMesExists(
                    context: context,
                    mes: _mes,
                    meses: c.value.Meses,
                    onExtraDelete: BorrarGasto,
                    onExtraSave: GuardarGasto,
                    onExtras: ()async {
                      await cuentaDao().almacenarDatos(c.value);
                        positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Extras(cuenta: c.value,))).then((value) =>c.value = Values().cuentaRet!
                        );
                    },
                    onIngresoChange: (ingreso)=>c.value.Meses.where((element) => element.NMes == _mes.value && element.Anno == Values().anno.value).first.Ingreso = double.parse(ingreso),
                    theme: Theme.of(context)
                  )
                  : iw.bodyMesNotExists(
                    mes: _mes,
                    onCrearMes: CrearMes,
                    onNuevoIngreso: UpdateIngreso,
                    theme: Theme.of(context)
                  )
              ),
            ),
          )
        ),
      )
    );
  }
}
