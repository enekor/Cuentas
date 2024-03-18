import 'package:cuentas_android/models/Mes.dart';
import 'package:cuentas_android/themes/DarkTheme.dart';
import 'package:cuentas_android/themes/LightTheme.dart';
import 'package:cuentas_android/values.dart';
import 'package:cuentas_android/widgets/GastoView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

List<Widget> GetGastos({required List<Mes> meses, required RxString mes, required Function(String,double) onSave, required Function(String,double) onDelete, required Function onIWTap}) {
    List<Widget> ret = [];
    int contador = 0;

    meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.Gastos.forEach((gasto) {
      if (gasto.valor > 0) {
        ret.add( GastoView(
          (name, value) => onSave,
          (name, value) => onDelete,
          gasto.nombre,
          gasto.valor,
          contador)
        );
      }
      contador++;
    });

    ret.add(Padding(
      padding: const EdgeInsets.all(30.0),
      child: InkWell(
        onTap: ()=>onIWTap(),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Extras"),
              Text("${meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.GetExtras().toStringAsFixed(2)}€")
            ],
          ),
        ),
      ),
    ));

    contador++;
    return ret;
  }

  List<Widget> GetIngresos({required List<Mes> meses, required RxString mes, required Function(String,double) onSave, required Function(String,double) onDelete, required Function onIWTap}) {
    List<Widget> ret = [];
    int contador = 0;

    meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.Gastos.forEach((gasto) {
      if (gasto.valor < 0) {
        ret.add( GastoView(
          (name, value) => onSave,
          (name, value) => onDelete,
          gasto.nombre,
          gasto.valor * -1,
          contador)
        );
      }
      contador++;
    });

    contador++;
    return ret;
  }

  Widget appBarMesExists({required double width, required RxString mes,required RxList<Mes> meses, required String nCuenta, required double total}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediaQuery(
          data: MediaQueryData.fromView(
              WidgetsBinding.instance.window),
          child: SizedBox(
            width: width * 0.5,
            child: Card(
                child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                Text(mes.value),
                Text("${meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.GetAhorros().toStringAsFixed(2)}€")
              ],
            )),
          ),
        ),
        SizedBox(
          width: width * 0.6,
          child: Card(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(nCuenta),
                  Text("${total.toStringAsFixed(2)}€")
              ])),
        )
      ],
    );
  }

  void showIngresoModalSheet({required BuildContext context, required Function(String) onIngresoChange, required List<Mes> meses, required RxString mes, required Function(String,double) onExtraIngresoDelete,required Function(String,double) onExtraIngresoSave,required RxInt ingresoSeleccionado, required Function(String,double) GuardarIngreso}){

    String _nombrenuevo = "";
    double _valorNuevo = 0;
    RxBool ingresoEditar = false.obs;
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (context) => Obx(
          () => Padding(
            padding:const EdgeInsets.all(10),
            child: Column(
              children: [
                //editar y ver ingreso base
                ingresoEditar.value
                    ? Row(
                        children: [
                          const Text("Ingresos"),
                          Expanded(
                            child:TextField(
                              keyboardType:TextInputType.number,
                              decoration:const InputDecoration(labelText: "Monto"),
                              onChanged:(v)=>onIngresoChange
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () =>ingresoEditar.value = false,
                          )
                        ],
                      )
                    : GestureDetector(
                        onTap: () =>ingresoEditar.value =true,
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("Ingresos"),
                            Text(meses.where((v) =>v.NMes ==mes.value && v.Anno == Values().anno.value).first.Ingreso.toString()),
                          ],
                        ),
                      ),
                //ver ingresos extra
                Column(
                  children:GetIngresos(
                    meses: meses,
                    mes: mes,
                    onDelete: onExtraIngresoDelete,
                    onSave: onExtraIngresoSave,
                    onIWTap: (){}
                  )),
                  ingresoSeleccionado.value ==-2
                  ? Row(
                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                      children: [
                          Expanded(
                            child:
                                IconButton(
                              icon: const Icon(Icons.check),
                              color: Colors.green,
                              onPressed:
                                  (){
                                    GuardarIngreso;
                                    ingresoSeleccionado.value =-1;
                                  }
                                
                            ),
                          ),
                          const SizedBox( width:10),
                          Expanded(
                            flex: 2,
                            child:TextField(
                              decoration:const InputDecoration(labelText: "Nombre"),
                              onChanged:(v) =>_nombrenuevo =v,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            flex: 2,
                            child:
                                TextField(
                              keyboardType:TextInputType.number,
                              decoration:const InputDecoration(labelText: "Monto"),
                              onChanged:(v) =>_valorNuevo =double.parse(v),
                            ),
                          ),
                        ])
                  : const SizedBox(),
                FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () =>ingresoSeleccionado.value = -2,
                )
              ],
            ),
          ),
        )
    );
  }

  void showGastosModalSheet({required BuildContext context, required List<Mes> meses, required RxString mes, required Function(String,double) onExtraGastoDelete,required Function(String,double) onExtraGastoSave,required RxInt gastoSeleccionado, required Function navigateToExtras}){

    String _nombrenuevo = "";
    double _valorNuevo = 0;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Obx(
        () => Padding(
          padding:const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize:MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: GetGastos(
                  mes:mes,
                  meses: meses,
                  onDelete: onExtraGastoDelete,
                  onSave: onExtraGastoSave,
                  onIWTap: navigateToExtras
                ),
              ),
              gastoSeleccionado.value == -2
                ? Row(children: [
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: ()=>onExtraGastoSave(_nombrenuevo,-1+_valorNuevo)
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration:const InputDecoration(labelText:"Nombre"),
                        onChanged: (v) => _nombrenuevo = v
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        keyboardType:TextInputType.number,
                        decoration:const InputDecoration(labelText:"Monto"),
                        onChanged: (v) => _valorNuevo = double.parse(v)
                      ),
                    ),
                  ])
                : const SizedBox(),
              FloatingActionButton(
                onPressed: () =>gastoSeleccionado.value = -2,
                child: const Icon(Icons.add)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyMesExists({required ThemeData theme,required RxString mes, required BuildContext context, required Function(String) onIngresoChange, required Function(String,double) onExtraSave, required Function(String,double) onExtraDelete, required List<Mes> meses, required Function onExtras}){
    RxInt gastoEditar = (-1).obs;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: DropdownButtonFormField(
            dropdownColor: theme.primaryColor,
            decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                fillColor:
                    theme.primaryColor),
            value: mes.value,
            items: Values().nombresMes.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (item) {
              mes.value = item.toString();
              Values().ChangeMes(mes.value);
            },
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //ingresos
            Expanded(
              flex: 5,
              child: InkWell(
                onTap: () => showIngresoModalSheet(
                  context: context,
                  GuardarIngreso: (n,v)=>onExtraSave(n,-1*v),
                  ingresoSeleccionado: gastoEditar,
                  mes: mes,
                  meses: meses,
                  onExtraIngresoDelete: (n,v)=>onExtraDelete(n,-1+v),
                  onExtraIngresoSave: (n,v)=>onExtraSave(n,-1*v),
                  onIngresoChange: onIngresoChange
                ),
                child: Card(
                  color: theme.brightness == Brightness.dark
                    ?AppColorsD.okButtonColor
                    :AppColorsL.okButtonColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text("Ingresos"),
                      Text("${meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.GetIngresos().toStringAsFixed(2)}€")
                    ],
                  ),
                ),
              ),
            ),
            //gastos
            Expanded(
              flex: 5,
              child: InkWell(
                child: Card(
                  color: theme.brightness == Brightness.dark
                    ? AppColorsD.errorButtonColor
                    :AppColorsL.errorButtonColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text("Gastos"),
                      Text("${meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.GetGastos().toStringAsFixed(2)}€")
                    ],
                  ),
                ),
                onTap: () => showGastosModalSheet(
                  context: context,
                  gastoSeleccionado: gastoEditar,
                  mes: mes,
                  meses: meses,
                  navigateToExtras: onExtras,
                  onExtraGastoDelete: onExtraDelete,
                  onExtraGastoSave: onExtraSave
                )
              )
            )
          ]
        ),
      ],
    );
  }

  Widget bodyMesNotExists({required RxString mes, required Function(String,double) onNuevoIngreso, required Function(String,double) onCrearMes, required ThemeData theme}){

    double ingreso = 0;
    return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.network(
        "https://cdn.icon-icons.com/icons2/1632/PNG/512/62878dollarbanknote_109277.png",
        height: 100,
        width: 100,
      ),
      const SizedBox(height: 80),
      Text("¿Cuanto se ha ingresado en ${mes.value}?"),
      const SizedBox(
        height: 10,
      ),
      TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: "Ingreso para ${mes.value}"),
        onChanged: (v) => ingreso = double.parse(v)
      ),
      const SizedBox(
        height: 10,
      ),
      IconButton(
        onPressed: ()=>onCrearMes(mes.value,ingreso),
        icon: const Icon(Icons.check),
        color: theme.brightness == Brightness.dark
          ? AppColorsD.okButtonColor
          : AppColorsL.okButtonColor
      )
      ]
    );
  }