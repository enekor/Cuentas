import 'package:flutter/material.dart';
import 'package:flutter_app/values.dart';
import 'package:flutter_app/models/Cuenta.dart';
import 'package:flutter_app/models/Mes.dart';
import 'package:flutter_app/home/home.dart';
import 'package:flutter_app/widgets/GastoView.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
RxInt GastoSeleccionado = new RxInt(-1);

class Info extends StatefulWidget {
  const Info({ Key? key }) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String mes = Values().nombresMes[(DateTime.now().month)-1];
  Cuenta c = Values().cuentas[Values().seleccionado];
  String nombrenuevo = "Gasto";
  double valornuevo = 0;
  RxBool mostrarGastos = false.obs;

//metodos
  bool HayDatos(){
    bool exists = c.Meses.where((v)=>v.NMes == mes).isNotEmpty;
    if(!exists){
      c.Meses.add(new Mes(mes));
      return false;
    }
    else{
      return true;
    }
  }

  void ChangeIngreso(double valor){
    c.Meses.where((v)=>v.NMes == mes).first.Ingreso = valor;
  }


  List<Widget> GetGastos(){
    List<Widget> ret = [];
    int contador = 0;

    ret.add(Text(GastoSeleccionado.toString()));

    c.Meses.where((v)=>v.NMes == mes).first.Gastos.forEach((nombre,valor){
      ret.add(GastoView(
        (name, value) {
          setState(() {
            nombre = name;
            valor = value;
          });
        },
        (name,value) => setState(() {
          c.Meses.where((v)=>v.NMes==mes).first.Gastos.removeWhere((n,v)=>v==value && n==name);
        }),
        (counter) => setState(() {
          GastoSeleccionado.value = counter;
        }),
        nombre,
        valor,
        GastoSeleccionado,
        contador
      ));
      contador++;
    });

    ret.add(Row(
      children: [
        Text("Extras"),
        Text(c.Meses.where((v)=>v.NMes==mes).first.GetExtras().toString())
      ],
    ));
    
    contador++;
    return ret;
  }

//pantalla
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder:(context)=>Home())
        );
        return true;
      },
      child: Obx(()=> Scaffold(
          floatingActionButton: mostrarGastos.value
          ?FloatingActionButton(
            onPressed: (){},
            child: Icon(Icons.add),
          )
          :Container(),
          appBar:AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: c.Meses.where((v)=>v.NMes == mes).isNotEmpty
              ?Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(c.Nombre),
                  Text(c.Meses.where((v)=>v.NMes == mes).first.GetAhorros().toString()+"€")
                ],
              )
              :Text("Inicio de mes"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: HayDatos()
              ?Column(
                 mainAxisSize:MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      icon: Icon(Icons.arrow_downward),
                      value: mes,
                      items: Values().nombresMes.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (item){
                        mes = item!;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: Column(
                             mainAxisSize:MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ingresos"),
                              Text(c.Meses.where((v)=>v.NMes==mes).first.Ingreso.toString())
                            ],
                          ),
                        ),
                        InkWell(
                          child: Card(
                            child: Column(
                              mainAxisSize:MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Gastos"),
                                Text(c.Meses.where((v)=>v.NMes==mes).first.GetGastos().toString())
                              ],
                            ),
                          ),
                          onTap: ()=>mostrarGastos.value = !mostrarGastos.value
                        )
                      ],
                    ),
                    mostrarGastos.value
                      ?Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize:MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize:MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.center,
                                children: GetGastos(),
                              ),
                              GastoSeleccionado.value == -2
                                ?Row(
                                  children:[
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.check),
                                        onPressed: ()=>setState(() {
                                          c.Meses.where((v)=>v.NMes==mes).first.Gastos[nombrenuevo] = valornuevo;
                                          GastoSeleccionado.value = -1;
                                        }),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      flex:2,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: "Nombre"
                                        ),
                                        onChanged: (v){
                                          nombrenuevo = v;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      flex:2,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: "Monto"
                                        ),
                                        onChanged: (v){
                                          valornuevo = double.parse(v);
                                        },
                                      ),
                                    ),

                                  ]
                                )
                                :SizedBox(),
                              IconButton(
                                icon:Icon(Icons.add),
                                onPressed: ()=>setState(() {
                                  GastoSeleccionado.value = -2;
                                }),
                              )
                            ],
                          ),
                      )
                      :SizedBox()
                  ],
                )
              :Column(
                mainAxisSize:MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Icon(Icons.euro,size: 50,color:Colors.yellow),
                  SizedBox(height: 80,),
                  Text("¿Cuanto se ha ingresado en "+mes+"?"),
                  SizedBox(height: 10,),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Ingreso para "+mes
                    ),
                    onChanged: (v){
                      ChangeIngreso(double.parse(v));
                    },
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        Values().cuentas[Values().seleccionado] = c;
                      });
                    },
                    child: Text("Confirmar")
                  )
                ]
              ),
            ),
          )
        ),
      ),
    );
  }
}