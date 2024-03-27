import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/dao/userDao.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/pantallas/info.dart';
import 'package:cuentas_android/pattern/positions.dart';
import 'package:cuentas_android/values.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/pattern/pattern.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/Get.dart';
import 'package:cuentas_android/home/homeWidgets.dart' as hw;

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  RxList<Cuenta> _cuentas = RxList([]);
  RxBool _vuelto = false.obs;
  RxBool _cargado = false.obs;

  String nuevoNombre = "";

  Future _getCuentas()async{
    if(!_vuelto.value){
      _cuentas.value = await cuentaDao().getDatos();
    }
    _cargado.value = true;
  }

  Future _logout() async{
    await Auth().signOut();
  }

  Future _createUser(BuildContext context)async{
    var cuenta = await cuentaDao().crearNuevaCuenta(nuevoNombre,_cuentas.length+1);
    _cuentas.add(cuenta);
    _vuelto.value = true;
    Navigator.pop(context);
  }

  void _navigateInfo(BuildContext context, Cuenta cuenta){
    positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
    Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => Info(cuenta:cuenta))
    ).then((value) {
      _cuentas.value.where((c) => c.id == cuenta.id).toList().first = Values().cuentaRet!;
      Values().anno.value = DateTime.now().year;
    });
  }

  void _deleteCuenta(Cuenta cuenta)async {
    _cuentas.value.remove(cuenta);
    await cuentaDao().deleteCuenta(cuenta);
  }

  @override
  Widget build(BuildContext context) {
    _getCuentas();
    return Obx(()=>_cargado.value
      ?Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton.extended(
          label: IconButton(onPressed:_logout,icon: const FaIcon(FontAwesomeIcons.rightFromBracket)),
          onPressed: ()=>hw.nuevoUsuario(
            context: context, 
            onChange: (value) => nuevoNombre = value, 
            onPressed: ()=>_createUser(context)
            ),
            icon: Icon(Icons.person_add),
        ),
        body: CustomPaint(
          painter: MyPattern(context),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder(
              future: _getCuentas(),
              builder:(c,s)=> s.connectionState == ConnectionState.done
              ? hw.hasData(
                context:context,
                cuentas: _cuentas,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                vuelto:(value)=>_vuelto.value = true,
                navigateInfo: (cuenta)=>_navigateInfo(context,cuenta),
                delete: (cuenta)=>_deleteCuenta(cuenta),
                logout: _logout
              )
              :Center(
                child: CircularProgressIndicator(color:Theme.of(context).primaryColor),
              )
            ),
          ),
        ),
      )
      :CircularProgressIndicator(color: Theme.of(context).primaryColor,)
    );
  }
}
