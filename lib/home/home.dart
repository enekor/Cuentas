import 'package:cuentas_android/dao/cuentaDao.dart';
import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/pattern/positions.dart';
import 'package:cuentas_android/themes/DarkTheme.dart';
import 'package:cuentas_android/themes/LightTheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_android/values.dart';
import 'package:cuentas_android/widgets/ItemView.dart';
import 'package:cuentas_android/pantallas/info.dart';
import 'package:cuentas_android/pattern/pattern.dart';
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

  Future getCuentas()async{
    cuentas = vuelto ? cuentas : await cuentaDao().getDatos();
  }

  @override
  void initState() {
    super.initState();

    positions().ChangePositions(1000,400);
  }

  RxBool seleccionarSummary = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex:6,
                            child: DropdownButtonFormField(
                              dropdownColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  fillColor:
                                      Theme.of(context).primaryColor),
                              value: Values().anno.value,
                              items: Values().GetAnnosDisponibles(cuentas).map((item) {
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
                            flex:4,
                            child: ElevatedButton(
                              onPressed: ()=>seleccionarSummary.value = !seleccionarSummary.value,
                              style: seleccionarSummary.value
                                ? ButtonStyle( backgroundColor: Theme.of(context).brightness == Brightness.dark
                                  ? MaterialStateProperty.all( AppColorsD.errorButtonColor)
                                  :MaterialStateProperty.all(AppColorsL.errorButtonColor)
                                )
                                : ButtonStyle( backgroundColor: Theme.of(context).brightness == Brightness.dark
                                  ? MaterialStateProperty.all( AppColorsD.okButtonColor)
                                  :MaterialStateProperty.all( AppColorsL.okButtonColor)
                                ),
                              child: seleccionarSummary.value
                                ? const Text("Cancelar")
                                : const Text("Mostrar historial"),
                            )
                          )
                        ],
                      ),
                      seleccionarSummary.value
                        ? const Text("Selecciona una cuenta para ver el historial")
                        : const SizedBox(),
                      Row(
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
                                child: ItemCard(cuenta.Nombre,
                                    cuenta.GetTotal(Values().anno.value))))
                            .toList()
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
