import 'models/Cuenta.dart';

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
    new Cuenta(1,"Nombre",[]),
    new Cuenta(2,"Nombre2",[])
  ];

  int seleccionado = -1;

  void seleccionar(int id){
    seleccionado = cuentas.indexOf(cuentas.where((v)=>v.id==id).first);
  }
}