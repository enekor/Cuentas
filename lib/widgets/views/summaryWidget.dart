import 'package:cuentas_android/models/Mes.dart';
import 'package:cuentas_android/themes/LightTheme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Widget> showSummary(List<Mes> meses, BuildContext context){
  List<Widget> ret = [];
  List<int> annos = meses.map((e) => e.Anno).toSet().toList();

  for(int anno in annos){
    ret.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FaIcon(FontAwesomeIcons.caretDown),
              Text(anno.toString(),style: Theme.of(context).textTheme.bodyLarge, ),
              FaIcon(FontAwesomeIcons.caretDown),
            ],
          ),
          Column(
            children: meses.where((element) => element.Anno == anno).map<Widget>((e) => 
              Column(
                children: [
                  Text(e.NMes,style: Theme.of(context).textTheme.bodyLarge,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text("Gastos fijos")
                      ),
                      Expanded(
                        flex: 7,
                        child: showGastos(e,context)
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text("Gastos extra")),
                      Expanded(
                        flex: 7,
                        child: showExtras(e,context)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text("Ingresos extra")),
                      Expanded(
                        flex: 7,
                        child: showIngresos(e,context)),
                    ],
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Expanded(
                        flex:3,
                        child: Text("Ingreso")
                      ),
                      Expanded(
                        flex:7,
                        child: Card(
                          color: AppColorsL.okButtonColor,
                          child: Center(child: Text("${e.Ingreso.toStringAsFixed(2)}€"),),
                        )
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top:10,bottom: 10),
                    child: Divider(),
                  )
                ],
              )
            ).toList()
          )
        ],
      ),
    ));
  }

  return ret;
}
Widget showGastos(Mes mes,BuildContext context) => 
  mes.Gastos.where((element) => element.valor>0).isNotEmpty
  ?Card(
    color:Theme.of(context).primaryColor,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mes.Gastos.where((element) => element.valor>0).map<Widget>((e) => 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                e.nombre,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                ),
              ),
              Text("${e.valor.toStringAsFixed(2)}€")
            ],
          )
        ).toList(),
      ),
    ),
  )
  :const Text("No hay",textAlign: TextAlign.center,);

Widget showExtras(Mes mes, BuildContext context) =>
  mes.Extras.isNotEmpty
  ?Card(
    color:Theme.of(context).primaryColor,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mes.Extras.map((e) => 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(e.nombre),
              Text("${e.valor.toStringAsFixed(2)}€")
            ],
          )  
        ).toList(),
      ),
    ),
  )
  :const Text("No hay",textAlign: TextAlign.center,);

Widget showIngresos(Mes mes, BuildContext context) =>
  mes.Gastos.where((element) => element.valor<0).isNotEmpty
  ?Card(
    color:Theme.of(context).primaryColor,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mes.Gastos.where((element) => element.valor<0).map<Widget>((e) => 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(e.nombre),
              Text("${(-1*e.valor).toStringAsFixed(2)}€")
            ],
          )
        ).toList(),
      ),
    ),
  )
  :const Text("No hay",textAlign: TextAlign.center,);

Widget summaryView(List<Mes> meses, BuildContext context) =>
  Center(
    child: Column(
      children: showSummary(meses,context).map<Widget>((e) => 
        Card(child: e,)
      ).toList()
    ),
  );

