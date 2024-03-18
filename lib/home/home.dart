import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/dao/userDao.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/pattern/pattern.dart';
import 'package:get/Get.dart';
import 'package:cuentas_android/home/homeWidgets.dart' as hw;

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  RxList<Cuenta> cuentas = RxList([]);
  RxBool vuelto = false.obs;
  RxBool cargado = false.obs;
  RxBool seleccionarSummary = false.obs;

  String nuevoNombre = "";

  Future _getCuentas()async{
    if(!vuelto.value){
      cuentas.value = await cuentaDao().getDatos();
    }
    cargado.value = true;
  }

  Future logout() async{
    await Auth().signOut();
  }


  @override
  Widget build(BuildContext context) {
    _getCuentas();
    return Obx(()=>cargado.value
      ?Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          onPressed: ()=>hw.nuevoUsuario(
            context: context, 
            onChange: (value) => nuevoNombre = value, 
            onPressed: () async{
              cuentas.add(await cuentaDao().crearNuevaCuenta(nuevoNombre,cuentas.length+1));
              vuelto.value = true;
            }),
          child: const Icon(Icons.person_add),
        ),
        appBar: AppBar(
          title: Obx(()=> cargado.value 
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: 
                  [
                    hw.selectYear(
                      cc: cuentas.value, 
                      width: MediaQuery.of(context).size.width, 
                      theme: Theme.of(context), 
                      selecSummary: (value) =>seleccionarSummary.value = value
                    ),
                    IconButton(
                      onPressed: logout /*cuentaDao().migrardatos*/, 
                      icon: const Icon(Icons.logout)
                    )
                  ]
                ) 
              : CircularProgressIndicator(color:Theme.of(context).primaryColor,),
          ),
          backgroundColor: Colors.transparent,
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
                cuentas: cuentas,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                seleccionarSummary: seleccionarSummary,
                vuelto:(value)=>vuelto.value = true
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
