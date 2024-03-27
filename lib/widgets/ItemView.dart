import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/Get.dart';

Widget ItemCard(String nombre,double ahorro, {required Function open, required Function delete}) {
  RxBool seleccionado = false.obs;
  RxString text = nombre.obs;

  return Obx(()=> InkWell(
      onTap: ()=>open(),
      onLongPress: ()=>seleccionado.value = !seleccionado.value,
      onSecondaryTap: ()=>seleccionado.value = !seleccionado.value,
    child: Card(
      child: Column(
        children: [
          const Icon(
            Icons.face,
            color: Colors.amber,
            size:50.0
          ),
          Text(text.value),
          Text("${ahorro.toStringAsFixed(2)}€"),
          seleccionado.value
            ?Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: () {
                  seleccionado.value = false;
                  open();
                }, icon: const FaIcon(FontAwesomeIcons.squareUpRight)),
                IconButton(onPressed: () {
                  seleccionado.value = false;
                  text.value = "Borrado";
                  delete();
                },icon: const FaIcon(FontAwesomeIcons.trash))
              ],
            )
            :Container()
          ],
        )
      ),
    ),
  );
}

Widget CardButton({required Function onPressed, required Widget child})=>
  InkWell(
    onTap: ()=>onPressed(),
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: child,
      ),
    ),
  );

