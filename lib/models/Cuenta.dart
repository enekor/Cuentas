import 'dart:convert';

import 'package:cuentas_android/models/Mes.dart';

class Cuenta{
  int id;
  String Nombre;
  List<Mes> Meses;

  Cuenta({required this.id,required this.Nombre,required this.Meses});

  factory Cuenta.fromJson(Map<String, dynamic> json) => Cuenta(
    id: json["id"],
    Nombre: json["Nombre"],
    Meses: List<Mes>.from(json["Meses"].map((x) => Mes.fromJson(x))),
  );

    Map<String, dynamic> toJson() => {
        "id": id,
        "Nombre": Nombre,
        "Meses": List<dynamic>.from(Meses.map((x) => x.toJson())),
    };

  double GetGastosTotales(){
    double ret = 0;
    for(Mes mes in Meses){
      ret+=mes.GetGastos();
    }

    return ret;
  }

  double GetTotal(){
    double ret = 0;

    for(Mes mes in Meses){
      ret+=mes.GetAhorros();
    }

    return ret;
  }
}