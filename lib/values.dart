import 'package:cuentas_android/models/Gasto.dart';
import 'package:cuentas_android/models/Mes.dart';

import 'models/Cuenta.dart';
import 'package:get/get.dart';

class Values {
  static final Values _apiInstace = Values._internal();

  factory Values() {
    return _apiInstace;
  }
  Values._internal();

  final nombresMes = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  List<Cuenta> cuentas = [
    Cuenta(
      id:1,
      Nombre: "Eneko",
      Meses: [
        Mes.complete(
          Gastos: 
          [
            Gasto(nombre: "nombre", valor: 1)
          ], 
          Extras: 
          [
            Gasto(nombre: "nombre", valor: 1)
          ], 
          Ingreso: 1, 
          NMes: "Enero"
        )
      ]
    ),
    Cuenta(
      id:2,
      Nombre: "Karolanne",
      Meses: [
        Mes.complete(
          Gastos: 
          [
            Gasto(nombre: "nombre", valor: 1)
          ], 
          Extras: 
          [
            Gasto(nombre: "nombre", valor: 1)
          ], 
          Ingreso: 1, 
          NMes: "Enero"
        )
      ]
    ),

  ];

  int seleccionado = -1;
  RxInt mes = new RxInt(DateTime.now().month-1);

  void seleccionar(int id){
    seleccionado = cuentas.indexOf(cuentas.where((v)=>v.id==id).first);
  }

  String GetMes() => nombresMes[mes.value];
  void ChangeMes(String m)=>mes.value = nombresMes.indexOf(m);
  
}