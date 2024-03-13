import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/models/Gasto.dart';
import 'package:cuentas_android/pattern/pattern.dart';
import 'package:cuentas_android/pattern/positions.dart';
import 'package:cuentas_android/themes/DarkTheme.dart';
import 'package:cuentas_android/themes/LightTheme.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/values.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/models/Mes.dart';
import 'package:cuentas_android/widgets/GastoView.dart';
import 'package:get/get.dart';
import 'package:cuentas_android/pantallas/extras.dart';

RxInt GastoSeleccionado = new RxInt(-1);

class Info extends StatefulWidget {
  Cuenta c;
  Info({Key? key, required this.c}) : super(key: key);

  @override
  _InfoState createState() => _InfoState(c);

}

class _InfoState extends State<Info> {
  RxString mes = Values().GetMes().obs;
  late Cuenta c;
  String nombrenuevo = "Gasto";
  double valornuevo = 0;
  RxBool mostrarGastos = false.obs;
  RxBool ingresoEditar = false.obs;
  double nuevoIngreso = -1;

  _InfoState(this.c);

//metodos
  bool HayDatos() {
    bool exists = c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).isNotEmpty;
    return exists;
  }

  void CrearMes() {
    if(c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).isEmpty){
      c.Meses.add(Mes(mes.value,Values().anno.value));
    }
      c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.Ingreso = nuevoIngreso;
  }

  void GuardarGasto(String nombre, double valor) {
    setState(() {
      var gastos = c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.Gastos;
      if (gastos.where((v) => v.nombre == nombre).isNotEmpty) {
        gastos.where((v) => v.nombre == nombre).first.valor = valor;
      } else {
        gastos.add(Gasto(nombre: nombre, valor: valor));
      }
    });
  }

  List<Widget> GetGastos() {
    List<Widget> ret = [];
    int contador = 0;

    c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.Gastos.forEach((gasto) {
      if (gasto.valor > 0) {
        ret.add(GastoView(
            (name, value) => setState(() {
                  GuardarGasto(name, value);
                }),
            (name, value) => setState(() {
                  c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value)
                      .first
                      .Gastos
                      .removeWhere((v) => v.valor == value && v.nombre == name);
                }),
            (counter) => setState(() {
                  GastoSeleccionado.value = counter;
                }),
            gasto.nombre,
            gasto.valor,
            contador));
      }
      contador++;
    });

    ret.add(Padding(
      padding: const EdgeInsets.all(30.0),
      child: InkWell(
        onTap: () async {
          await cuentaDao().almacenarDatos(c);
          positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => Extras(cuenta: c,))).then((value) => setState(()=>c = Values().cuentaRet!));
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Extras"),
              Text(
                  "${c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.GetExtras()}€")
            ],
          ),
        ),
      ),
    ));

    contador++;
    return ret;
  }

  List<Widget> GetIngresos() {
    List<Widget> ret = [];
    int contador = 0;

    c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.Gastos.forEach((gasto) {
      if (gasto.valor < 0) {
        ret.add(GastoView(
            (name, value) => setState(() {
                  GuardarGasto(gasto.nombre, value * -1);
                }),
            (name, value) => setState(() {
                  c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value)
                      .first
                      .Gastos
                      .removeWhere(
                          (g) => g.valor == value * -1 && g.nombre == name);
                }),
            (counter) => setState(() {
                  GastoSeleccionado.value = counter;
                }),
            gasto.nombre,
            gasto.valor * -1,
            contador));
      }
      contador++;
    });

    contador++;
    return ret;
  }

//pantalla
  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (_) async {
          positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
          await cuentaDao().almacenarDatos(c);
          Values().cuentaRet = c;
        },
        child: Obx(
          () => Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                centerTitle: false,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0.0,
                title: c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MediaQuery(
                            data: MediaQueryData.fromView(
                                WidgetsBinding.instance.window),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Card(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(mes.value),
                                  Text(
                                      "${c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.GetAhorros()}€")
                                ],
                              )),
                            ),
                          ),
                          MediaQuery(
                            data: MediaQueryData.fromView(
                                WidgetsBinding.instance.window),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Card(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                    Text(c.Nombre),
                                    Text("${c.GetTotal(Values().anno.value)}€")
                                  ])),
                            ),
                          )
                        ],
                      )
                    : const Text("Inicio de mes"),
              ),
              body: CustomPaint(
                painter: MyPattern(context),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: HayDatos()
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: DropdownButtonFormField(
                                  dropdownColor: Theme.of(context).primaryColor,
                                  decoration: InputDecoration(
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      fillColor:
                                          Theme.of(context).primaryColor),
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
                                    Expanded(
                                      flex: 5,
                                      child: InkWell(
                                        onTap: () => showModalBottomSheet(
                                          isScrollControlled: true,
                                            context: context,
                                            builder: (context) => Obx(
                                                  () => Padding(
                                                    padding:const EdgeInsets.all(10),
                                                    child: Column(
                                                      children: [
                                                        ingresoEditar.value
                                                            ? Row(
                                                                children: [
                                                                  const Text("Ingresos"),
                                                                  Expanded(
                                                                    child:TextField(
                                                                      keyboardType:TextInputType.number,
                                                                      decoration:const InputDecoration(labelText: "Monto"),
                                                                      onChanged:(v) {
                                                                        setState(
                                                                          () {
                                                                            c.Meses.where((cuenta) => cuenta.NMes == mes.value && cuenta.Anno == Values().anno.value).first.Ingreso = double.parse(v);
                                                                          }
                                                                        );
                                                                      },
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
                                                                    Text(c.Meses.where((v) =>v.NMes ==mes.value && v.Anno == Values().anno.value).first.Ingreso.toString()),
                                                                  ],
                                                                ),
                                                              ),
                                                        Column(
                                                            children:GetIngresos()),
                                                            GastoSeleccionado.value ==-2
                                                            ? Row(
                                                                mainAxisAlignment:MainAxisAlignment.spaceAround,
                                                                children: [
                                                                    Expanded(
                                                                      child:
                                                                          IconButton(
                                                                        icon: const Icon(Icons.check),
                                                                        color: Colors.green,
                                                                        onPressed:
                                                                            () =>setState(() {
                                                                          GuardarGasto(nombrenuevo,-1*valornuevo);
                                                                          GastoSeleccionado.value =-1;
                                                                        }),
                                                                      ),
                                                                    ),
                                                                    const SizedBox( width:10),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:TextField(
                                                                        decoration:const InputDecoration(labelText: "Nombre"),
                                                                        onChanged:(v) =>nombrenuevo =v,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 10,),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          TextField(
                                                                        keyboardType:TextInputType.number,
                                                                        decoration:const InputDecoration(labelText: "Monto"),
                                                                        onChanged:(v) =>valornuevo =double.parse(v),
                                                                      ),
                                                                    ),
                                                                  ])
                                                            : const SizedBox(),
                                                        FloatingActionButton(
                                                          child: const Icon(Icons.add),
                                                          onPressed: () =>GastoSeleccionado.value = -2,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                        child: Card(
                                          color: Theme.of(context).brightness == Brightness.dark
                                            ?AppColorsD.okButtonColor
                                            :AppColorsL.okButtonColor,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text("Ingresos"),
                                              Text(
                                                  "${c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.GetIngresos()}€")
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 5,
                                        child: InkWell(
                                          child: Card(
                                            color: Theme.of(context).brightness == Brightness.dark
                                              ? AppColorsD.errorButtonColor
                                              :AppColorsL.errorButtonColor,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text("Gastos"),
                                                Text(
                                                    "${c.Meses.where((v) => v.NMes == mes.value && v.Anno == Values().anno.value).first.GetGastos()}€")
                                              ],
                                            ),
                                          ),
                                          onTap: () => showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) => Obx(
                                              () => Padding(
                                                padding:const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisSize:MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: GetGastos(),
                                                    ),
                                                    GastoSeleccionado.value == -2
                                                        ? Row(children: [
                                                            Expanded(
                                                              child: IconButton(
                                                                icon: const Icon(Icons.check),
                                                                onPressed: () =>setState(() {
                                                                  GuardarGasto(nombrenuevo,valornuevo);
                                                                  GastoSeleccionado.value = -1;
                                                                }),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: TextField(
                                                                decoration:const InputDecoration(labelText:"Nombre"),
                                                                onChanged: (v) {
                                                                  nombrenuevo =v;
                                                                },
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
                                                                onChanged: (v) {
                                                                  valornuevo =double.parse(v);
                                                                },
                                                              ),
                                                            ),
                                                          ])
                                                        : const SizedBox(),
                                                    FloatingActionButton(
                                                      onPressed: () =>GastoSeleccionado.value = -2,
                                                      child: const Icon(Icons.add)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                  ]),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Image.network(
                                  "https://cdn.icon-icons.com/icons2/1632/PNG/512/62878dollarbanknote_109277.png",
                                  height: 100,
                                  width: 100,
                                ),
                                const SizedBox(
                                  height: 80,
                                ),
                                Text(
                                    "¿Cuanto se ha ingresado en ${mes.value}?"),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: "Ingreso para ${mes.value}"),
                                  onChanged: (v) {
                                    nuevoIngreso = double.parse(v);
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                IconButton(
                                  onPressed: () =>setState(() {
                                    CrearMes();
                                  }),
                                  icon: const Icon(Icons.check),
                                  color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColorsD.okButtonColor
                                    : AppColorsL.okButtonColor
                                )
                              ]),
                  ),
                ),
              )),
        ));
  }
}
