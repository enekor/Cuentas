import 'dart:convert';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/models/Mes.dart';
import 'package:cuentas_android/values.dart';
import 'package:firebase_database/firebase_database.dart';

class cuentaDao{


  final database = FirebaseDatabase.instance;

  void obtenerDatos(){
    DatabaseReference cuenta1 = FirebaseDatabase.instance.ref('cuenta/1');
    cuenta1.onValue.listen((event) {
      final data = event.snapshot.value;
      Map<String,dynamic> datos = data as Map<String,dynamic>;
      Cuenta c = jsonDecode(datos.toString());
      Values().cuentas.add(c);
  });
  
    DatabaseReference cuenta2 = FirebaseDatabase.instance.ref('cuenta/2');
    cuenta2.onValue.listen((event) {
      final data = event.snapshot.value;
      Map<String,dynamic> datos = data as Map<String,dynamic>;
      Cuenta c = jsonDecode(datos.toString());
      Values().cuentas.add(c);
  });
  }

  void almacenarDatos() async {
    for(int i = 1;i<Values().cuentas.length;i++){
      DatabaseReference ref = FirebaseDatabase.instance.ref("cuenta/$i");

      await ref.set({
        'id':Values().cuentas[i].id,
        'Nombre':Values().cuentas[i].Nombre,
        'Meses':Values().cuentas[i].Meses.map((mes) => jsonEncode(mes)).toList()
      });
    }
  }
}