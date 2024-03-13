import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/pattern/positions.dart';
import 'package:cuentas_android/themes/DarkTheme.dart';
import 'package:cuentas_android/themes/LightTheme.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/values.dart';
import 'package:cuentas_android/widgets/ItemView.dart';
import 'package:cuentas_android/pantallas/info.dart';
import 'package:cuentas_android/pattern/pattern.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cuentas_android/pantallas/summary.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List<Cuenta> cuentas;
  bool vuelto = false;
  RxBool cargado = false.obs;
  String nuevoNombre = "";

  Future getCuentas()async{
    if(!vuelto){
      cuentas = await cuentaDao().getDatos();
    }

    int aa = cuentas.length;
    cargado.value = true;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget selectYear(List<Cuenta> cc)=>
    SizedBox(
      width: MediaQuery.of(context).size.width/2,
      child: Padding(
        padding: const EdgeInsets.only(top:8.0,left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex:8,
              child: DropdownButtonFormField(
                dropdownColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    fillColor: Theme.of(context).primaryColor,
                    contentPadding: EdgeInsets.all(8)
                  ),
                value: Values().anno.value,
                items: Values().GetAnnosDisponibles(cc).map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  );
                }).toList(),
                onChanged: (item) {
                  Values().anno.value = item!;
                },
              ),
            ),
            Expanded(
              flex:2,
              child: IconButton(
                onPressed: ()=>seleccionarSummary.value = !seleccionarSummary.value,
                color: seleccionarSummary.value
                ? Theme.of(context).brightness == Brightness.dark
                  ? AppColorsD.errorButtonColor
                  :AppColorsL.errorButtonColor
                : Theme.of(context).brightness == Brightness.dark
                  ? AppColorsD.okButtonColor
                  :AppColorsL.okButtonColor,
                icon: const Icon(Icons.manage_search),
                ),
            )
          ],
        ),
      ),
    );

  void nuevoUsuario(){
    showModalBottomSheet(
      context: context, 
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Text("Nuevo usuario"),
              Expanded(
                child: TextField(
                  onChanged: (value) => nuevoNombre = value,
                  decoration: const InputDecoration(
                    labelText: "Nombre"
                  ),
                ),
              ),
              IconButton(
                onPressed: () async{
                  cuentas.add(await cuentaDao().crearNuevaCuenta(nuevoNombre));
                  setState(() {
                    vuelto = true;
                  });
                  Navigator.of(context).pop();
                }, 
                icon: const Icon(Icons.person_add_alt_1_rounded)
              )
            ],
          ),
        ),
      )
    );
  }

  RxBool seleccionarSummary = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: nuevoUsuario,
        child: const Icon(Icons.person_add),
      ),
      appBar: AppBar(
        title: cargado.value 
          ? selectYear(cuentas) 
          : CircularProgressIndicator(color: Theme.of(context).primaryColor,),
        backgroundColor: Colors.transparent,
      ),
        resizeToAvoidBottomInset: true,
        body: CustomPaint(
          painter: MyPattern(context),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder(
              future: getCuentas(),
              builder:(c,s)=> s.connectionState == ConnectionState.done
              ? Obx(()=>Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      seleccionarSummary.value
                        ? const Text("Selecciona una cuenta para ver el historial")
                        : const SizedBox(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: cuentas.map<Widget>((cuenta) => GestureDetector(
                                  onTap: () {
                                    positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
                                    Navigator.of(context).push(
                                      seleccionarSummary.value
                                        ?MaterialPageRoute(builder: (context)=> SummaryPage(cuenta: cuenta,))
                                        :MaterialPageRoute(builder: (context) => Info(c:cuenta))
                                      ).then((value) => setState(() {
                                        vuelto = true;
                                        cuenta = Values().cuentaRet!;
                                      }));
                                  },
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.width/4,
                                    width:  MediaQuery.of(context).size.width/4,
                                    child: Center(
                                      child: ItemCard(cuenta.Nombre,
                                          cuenta.GetTotal(Values().anno.value)),
                                    ),
                                  )))
                              .toList()
                        ),
                      ),
                    ],
                  ),
                ),
              )
              :CircularProgressIndicator(
                color: Theme.of(context).primaryColor
              )
            ),
          ),
        ),
      );
  }
}
