import 'dart:convert';

import 'package:cuentas_android/models/Mes.dart';

class Cuenta{
  String id;
  String Nombre;
  List<Mes> Meses;
  int posicion;

  Cuenta({required this.id,required this.Nombre,required this.Meses, required this.posicion});

  factory Cuenta.fromJson(Map<String, dynamic> json) => Cuenta(
    id: json["id"],
    Nombre: json["Nombre"],
    Meses: List<Mes>.from(json["Meses"].map((x) => Mes.fromJson(x))),
    posicion: json["posicion"]
  );

    Map<String, dynamic> toJson() => {
        "id": id,
        "Nombre": Nombre,
        "Meses": List<dynamic>.from(Meses.map((x) => x.toJson())),
        "posicion":posicion
    };

  double GetGastosTotales(int anno){
    double ret = 0;
    for(Mes mes in Meses.where((v)=>v.Anno == anno)){
      ret+=mes.GetGastos();
    }

    return ret;
  }

  double GetTotal(int anno){
    double ret = 0;

    for(Mes mes in Meses.where((v)=>v.Anno == anno)){
      ret+=mes.GetAhorros();
    }

    return ret;
  }
}