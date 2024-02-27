import 'package:flutter/material.dart';

Widget ItemCard(String nombre,double ahorro) => Container(
  height: 100,
  width: 100,
  child:   Card(
        
        child: Column(
          children: [
            Icon(
              Icons.beach_access,
              color: Colors.amber,
              size:50.0
            ),
            Text(nombre),
            Text(ahorro.toString()+"€")
          ],
        )
    ),
);
