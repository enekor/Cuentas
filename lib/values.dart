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
    new Cuenta(1,"Eneko",[]),
    new Cuenta(2,"Karolanne",[])
  ];

  int seleccionado = -1;
  RxInt mes = new RxInt(DateTime.now().month-1);

  void seleccionar(int id){
    seleccionado = cuentas.indexOf(cuentas.where((v)=>v.id==id).first);
  }

  String GetMes() => nombresMes[mes.value];
  void ChangeMes(String m)=>mes.value = nombresMes.indexOf(m);
  
}