import 'models/Cuenta.dart';

class Values {
  static final Values _apiInstace = Values._internal();

  factory Values() {
    return _apiInstace;
  }
  Values._internal();

  List<Cuenta> cuentas = [
    new Cuenta("Nombre",[]),
    new Cuenta("Nombre2",[])
  ];
}