import 'package:flutter/material.dart';
import 'package:cuentas_android/values.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/models/Mes.dart';
import 'package:cuentas_android/home/home.dart';
import 'package:cuentas_android/widgets/GastoView.dart';
import 'package:get/get.dart';
import 'package:cuentas_android/pantallas/extras.dart';
import 'package:animate_do/animate_do.dart';

RxInt GastoSeleccionado = new RxInt(-1);

class Info extends StatefulWidget {
  const Info({ Key? key }) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  RxString mes = Values().GetMes().obs;
  Cuenta c = Values().cuentas[Values().seleccionado];
  String nombrenuevo = "Gasto";
  double valornuevo = 0;
  RxBool mostrarGastos = false.obs;
  RxBool ingresoEditar = false.obs;

//metodos
  bool HayDatos(){
    bool exists = c.Meses.where((v)=>v.NMes == mes.value).isNotEmpty;
    if(!exists){
      c.Meses.add(new Mes(mes.value));
      return false;
    }
    else{
      return true;
    }
  }

  void ChangeIngreso(double valor){
    c.Meses.where((v)=>v.NMes == mes.value).first.Ingreso = valor;
  }

  List<Widget> GetGastos(){
    List<Widget> ret = [];
    int contador = 0;

    c.Meses.where((v)=>v.NMes == mes.value).first.Gastos.forEach((nombre,valor){
      ret.add(GastoView(
        (name, value) =>setState(() {
          c.Meses.where((v)=>v.NMes==mes.value).first.Gastos[nombre] = value;
        }),
        (name,value) => setState(() {
          c.Meses.where((v)=>v.NMes==mes.value).first.Gastos.removeWhere((n,v)=>v==value && n==name);
        }),
        (counter) => setState(() {
          GastoSeleccionado.value = counter;
        }),
        nombre,
        valor,
        contador
      ));
      contador++;
    });

    ret.add(InkWell(
      onTap: ()=>Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder:(context)=>Extras())
        ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Extras"),
            Text(c.Meses.where((v)=>v.NMes==mes.value).first.GetExtras().toString()+"€")
          ],
        ),
      ),
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
        resizeToAvoidBottomInset: true,
          appBar:AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: c.Meses.where((v)=>v.NMes == mes.value).isNotEmpty
              ?Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(c.Nombre),
                  Text(c.Meses.where((v)=>v.NMes == mes.value).first.GetAhorros().toString()+"€")
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
                      value: mes.value,
                      items: Values().nombresMes.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (item){
                        mes.value = item.toString();
                        Values().ChangeMes(mes.value);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex:5,
                          child: InkWell(
                            onTap: ()=>ingresoEditar.value = true,
                            child: Card(
                              child: Column(
                                 mainAxisSize:MainAxisSize.min,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Ingresos"),
                                  ingresoEditar.value
                                  ?Row(
                                    children: [
                                      IconButton(
                                        icon:Icon(Icons.check),
                                        onPressed: ()=>ingresoEditar.value = false,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Monto"
                                          ),
                                          onChanged: (v){
                                            setState(() {
                                              ChangeIngreso(double.parse(v));
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                  :Text(c.Meses.where((v)=>v.NMes==mes.value).first.Ingreso.toString())
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex:5,
                          child: InkWell(
                            child: Card(
                              child: Column(
                                mainAxisSize:MainAxisSize.min,
                               mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Gastos"),
                                  Text(c.Meses.where((v)=>v.NMes==mes.value).first.GetGastos().toString())
                                ],
                              ),
                            ),
                            onTap: ()=>showModalBottomSheet(
                              context:context,
                              builder: (context)=>Obx(()=>
                                Padding(
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
                                                    c.Meses.where((v)=>v.NMes==mes.value).first.Gastos[nombrenuevo] = valornuevo;
                                                    GastoSeleccionado.value = -1;
                                                  }),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              Expanded(
                                                flex:2,
                                                child: TextField(
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
                                          FloatingActionButton(
                                            onPressed:()=>GastoSeleccionado.value = -2,
                                            child: Icon(Icons.add)
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                ),
                              )
                            )
                          ),
                      ],
                    ),
                  ],
                )
              :Column(
                mainAxisSize:MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Icon(Icons.euro,size: 50,color:Colors.yellow),
                  SizedBox(height: 80,),
                  Text("¿Cuanto se ha ingresado en "+mes.value+"?"),
                  SizedBox(height: 10,),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Ingreso para "+mes.value
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