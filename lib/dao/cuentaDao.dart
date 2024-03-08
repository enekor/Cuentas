import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/values.dart';

class cuentaDao{

  CollectionReference ref = FirebaseFirestore.instance.collection('cuenta');

  void obtenerDatos() async {
    final snapshot = await ref.get();
    Values().cuentas = snapshot.docs.map((doc) => Cuenta.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }



  void almacenarDatos() async {
    for(Cuenta c in Values().cuentas){
      ref.doc(c.id.toString()).update(c.toJson());
    }
  }

}