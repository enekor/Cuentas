import 'package:cuentas_android/models/Gasto.dart';
import 'package:cuentas_android/models/Mes.dart';
import 'package:cuentas_android/themes/DarkTheme.dart';
import 'package:cuentas_android/themes/LightTheme.dart';
import 'package:cuentas_android/values.dart';
import 'package:cuentas_android/widgets/GastoView.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

List<Widget> GetGastos({required List<Mes> meses, required String mes, required Function(String,double) onSave, required Function(String,double) onDelete,required Function(int) onSelect, required Function onIWTap, required ThemeData theme}) {
    List<Widget> ret = [];
    int contador = 0;

    meses.where((v) => v.NMes == mes && v.Anno == Values().anno.value).first.Gastos.forEach((gasto) {
      if (gasto.valor > 0) {
        ret.add( gastoView(
          onSave,
          onDelete,
          onSelect,
          gasto.nombre,
          gasto.valor,
          contador,
          theme
          )
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
              Text("${meses.where((v) => v.NMes == mes && v.Anno == Values().anno.value).first.GetExtras().toStringAsFixed(2)}€")
            ],
          ),
        ),
      ),
    ));

    contador++;
    return ret;
  }

  List<Widget> GetIngresos({required List<Mes> meses, required String mes, required Function(String,double) onSave, required Function(String,double) onDelete,required Function(int) onSelected, required Function onIWTap, required ThemeData theme}) {
    List<Widget> ret = [];
    int contador = 0;

    meses.where((v) => v.NMes == mes && v.Anno == Values().anno.value).first.Gastos.forEach((gasto) {
      if (gasto.valor < 0) {
        ret.add( gastoView(
          onSave,
          onDelete,
          onSelected,
          gasto.nombre,
          gasto.valor * -1,
          contador,
          theme
          )
        );
      }
      contador++;
    });

    contador++;
    return ret;
  }

  Widget appBarMesExists({required double width, required String mes,required List<Mes> meses, required String nCuenta, required double total, required Function navigateSettings}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 9,
          child: Column(
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
                        Text(mes),
                        Text("${meses.where((v) => v.NMes == mes && v.Anno == Values().anno.value).first.GetAhorros().toStringAsFixed(2)}€")
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
          ),
        ),
        Expanded(
          flex:1,
          child: IconButton(icon: const Icon(Icons.receipt_long_rounded),onPressed: ()=>navigateSettings(),),
        )
      ],
    );
  }

  void showIngresoModalSheet({required BuildContext context, required Function(double) onIngresoChange, required List<Mes> meses, required String mes, required Function(String,double) onExtraIngresoDelete,required Function(String,double) onExtraIngresoSave, required Function(String,double) guardarIngreso, required Function(int) onSelected, required ThemeData theme, required List<Gasto> deleted}){

    String _nombrenuevo = "";
    double _valorNuevo = 0;
    bool ingresoEditar = false;
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (context) => Obx(()=> Padding(
              padding:const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //editar y ver ingreso base
                  ingresoEditar
                      ? Row(
                          children: [
                            const Text("Ingresos"),
                            Expanded(
                              child:TextField(
                                keyboardType:TextInputType.number,
                                decoration:const InputDecoration(labelText: "Monto"),
                                onChanged:(v)=>onIngresoChange(double.parse(v))
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () =>ingresoEditar = false,
                            )
                          ],
                        )
                      : GestureDetector(
                          onTap: () =>ingresoEditar =true,
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Ingresos"),
                              Text(meses.where((v) =>v.NMes ==mes && v.Anno == Values().anno.value).first.Ingreso.toString()),
                            ],
                          ),
                        ),
                  //ver ingresos extra
                  Column(
                    children:GetIngresos(
                      meses: meses,
                      mes: mes,
                      onDelete: (n,v)=>onExtraIngresoDelete(n,v),
                      onSave: (n,v)=>onExtraIngresoSave(n,v),
                      onSelected: onSelected,
                      onIWTap: (){},
                      theme: theme
                    )),
                    Values().gastoSeleccionado.value ==-2
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
                                      guardarIngreso(_nombrenuevo,_valorNuevo);
                                      Values().gastoSeleccionado.value =-1;
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
                    child: Values().gastoSeleccionado.value != -2
                      ? const Icon(Icons.add)
                      : const Icon(Icons.close),
                    onPressed: () => Values().gastoSeleccionado.value != -2
                      ?Values().gastoSeleccionado.value = -2
                      :Values().gastoSeleccionado.value = -1
                  )
                ],
              ),
            ),
        ),
    );
  }

  void showGastosModalSheet({required BuildContext context, required List<Mes> meses, required String mes, required Function(String,double) onExtraGastoDelete,required Function(String,double) onExtraGastoSave, required Function navigateToExtras, required Function(int) onSelected, required ThemeData theme}){

    String _nombrenuevo = "";
    double _valorNuevo = 0;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) =>Obx(()=> Padding(
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
                    onSelect: onSelected,
                    onIWTap: navigateToExtras,
                    theme: theme
                  ),
                ),
                Values().gastoSeleccionado.value == -2
                  ? Row(children: [
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: (){
                            onExtraGastoSave(_nombrenuevo,_valorNuevo);
                            Values().gastoSeleccionado.value = -1;
                          }
        
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
                  child: Values().gastoSeleccionado.value != -2
                    ? const Icon(Icons.add)
                    : const Icon(Icons.close),
                  onPressed: () => Values().gastoSeleccionado.value != -2
                    ?Values().gastoSeleccionado.value = -2
                    :Values().gastoSeleccionado.value = -1
                )
              ],
            ),
          ),
      ),
    );
  }

  Widget bodyMesExists({required ThemeData theme,required String mes, required BuildContext context, required Function(double) onIngresoChange, required Function(String,double) onExtraSave, required Function(String,double) onExtraDelete, required List<Mes> meses, required Function onExtras,required Function(int) onSelected, required List<Gasto> deleted, required Function(String) onSelecMes}){
    
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //selector de meses
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
              value: mes,
              items: Values().nombresMes.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (item) {
                mes = item.toString();
                Values().ChangeMes(mes);
                onSelecMes(mes);
              },
            ),
          ),
          //selector de gastos/ingresos
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
                    guardarIngreso: (n,v)=>onExtraSave(n,(-1)*v),
                    mes: mes,
                    meses: meses,
                    onExtraIngresoDelete: (n,v)=>onExtraDelete(n,(-1)*v),
                    onExtraIngresoSave: (n,v)=>onExtraSave(n,(-1)*v),
                    onSelected: onSelected,
                    onIngresoChange: (v)=>onIngresoChange(v),
                    theme: theme,
                    deleted:deleted
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
                        Text("${meses.where((v) => v.NMes == mes && v.Anno == Values().anno.value).first.GetIngresos().toStringAsFixed(2)}€")
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
                        Text("${meses.where((v) => v.NMes == mes && v.Anno == Values().anno.value).first.GetGastos().toStringAsFixed(2)}€")
                      ],
                    ),
                  ),
                  onTap: () => showGastosModalSheet(
                    context: context,
                    mes: mes,
                    meses: meses,
                    navigateToExtras: onExtras,
                    onExtraGastoDelete: onExtraDelete,
                    onExtraGastoSave: onExtraSave,
                    onSelected: onSelected,
                    theme: theme
                  )
                )
              )
            ]
          ),
        ],
    );
  }

  Widget bodyMesNotExists({required String mes, required Function(String,double) onNuevoIngreso, required Function(String,double) onCrearMes, required ThemeData theme}){

    TextEditingController controller = TextEditingController();
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
        Text("¿Cuanto se ha ingresado en ${mes}?"),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Ingreso para ${mes}"),
        ),
        const SizedBox(
          height: 10,
        ),
        IconButton(
          onPressed: ()=>onCrearMes(mes,double.parse(controller.text)),
          icon: const Icon(Icons.check),
          color: theme.brightness == Brightness.dark
            ? AppColorsD.okButtonColor
            : AppColorsL.okButtonColor
        )
        ]
    );
  }