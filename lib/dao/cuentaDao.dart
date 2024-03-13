import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuentas_android/dao/userDao.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';

class cuentaDao{

  CollectionReference ref = FirebaseFirestore.instance.collection('cuenta');
  User? user = Auth().currentUser ?? null;

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
    /*return List.generate(2, (index) => Cuenta(
      id: math.Random().nextDouble().toString(),
      Meses: [],
      Nombre: "nombre${index+1}",
      posicion: index+1
    ));
    */
    Query query = ref.where('uid', isEqualTo: user!.uid);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => Cuenta.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future migrardatos() async{
    var snapshot = await ref.get();
    List<Cuenta> datos = snapshot.docs.map((doc) => Cuenta.fromJson(doc.data() as Map<String, dynamic>)).toList();

    for(Cuenta c in datos){
      String doc = "${c.id}-${c.posicion}";
      ref.doc(doc).set(c.toJson());
    }
  }

  Future<Cuenta> crearNuevaCuenta(String nombre) async{
    var anteriores = await getDatos();
    Cuenta c = Cuenta(
      Meses: [],
      Nombre: nombre,
      id: user!.uid,
      posicion: anteriores.length+1,
    );

    await ref.doc("${c.id}-${c.posicion}").set(c.toJson());

    return c;
  }


  Future almacenarDatos(Cuenta c) async {
    
    await ref.doc("${c.id}-${c.posicion}").update(c.toJson());
    
  }

}