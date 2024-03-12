import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/values.dart';

class cuentaDao{

  CollectionReference ref = FirebaseFirestore.instance.collection('cuenta');

  Future obtenerDatos() async {
    /*
    final snapshot = await ref.get();
    Values().cuentas = snapshot.docs.map((doc) => Cuenta.fromJson(doc.data() as Map<String, dynamic>)).toList();
    */
    
    /*if(Values().cuentas.isEmpty){
      for(int i = 1;i<3;i++){
        Values().cuentas.add( Cuenta(
          id: i,
          Meses: [],
          Nombre: "nombre$i"
        ));
      }
    }*/
  }

  Future<List<Cuenta>> getDatos() async {
    return List.generate(2, (index) => Cuenta(
      id: index+1,
      Meses: [],
      Nombre: "nombre${index+1}"
    ));
    /*
    final snapshot = await ref.get();
    return snapshot.docs.map((doc) => Cuenta.fromJson(doc.data() as Map<String, dynamic>)).toList();
    */
  }



  Future almacenarDatos(Cuenta c) async {
    /*
    await ref.doc(c.id.toString()).update(c.toJson());
    */
  }

}