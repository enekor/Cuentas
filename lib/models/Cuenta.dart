import 'package:cuentas_android/models/Mes.dart';

class Cuenta{
  int id;
  String Nombre;
  List<Mes> Meses;

  Cuenta(this.id,this.Nombre,this.Meses);

  double GetGastosTotales(){
    double ret = 0;
    for(Mes mes in this.Meses){
      ret+=mes.GetGastos();
    }

    return ret;
  }

  double GetTotal(){
    double ret = 0;

    for(Mes mes in this.Meses){
      ret+=mes.GetAhorros();
    }

    return ret;
  }
}