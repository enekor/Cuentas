import 'package:cuentas_android/themes/DarkTheme.dart';
import 'package:cuentas_android/themes/LightTheme.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyPattern extends CustomPainter {
  late BuildContext context;
  MyPattern(this.context);

  final time = DateTime.now().millisecondsSinceEpoch;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random();
    final paint = Paint();
    ThemeData theme = Theme.of(context);
    bool claro = theme.brightness == Brightness.dark;


    //circulo
    paint.color = claro?AppColorsL.secondaryColor1:AppColorsD.secondaryColor1;
    canvas.drawCircle(Offset(random.nextDouble()*size.width, random.nextDouble()*size.height), 100, paint);

    paint.color = claro?AppColorsL.secondaryColor2:AppColorsD.secondaryColor2;
    canvas.drawCircle(Offset(random.nextDouble()*size.width, random.nextDouble()*size.height), 75, paint);

    paint.color = claro?AppColorsL.secondaryColor3:AppColorsD.secondaryColor3;
    canvas.drawCircle(Offset(random.nextDouble()*size.width, random.nextDouble()*size.height), 50, paint);

    paint.color = claro?AppColorsL.secondaryColor4:AppColorsD.secondaryColor4;
    canvas.drawCircle(Offset(random.nextDouble()*size.width, random.nextDouble()*size.height), 40, paint);

    paint.color = claro?AppColorsL.secondaryColor5:AppColorsD.secondaryColor5;

//ola
    Path path = Path()..moveTo(0, size.height/2);
    path.moveTo(0, size.height * 0.7 );
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.7 ,
        size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9 ,
        size.width * 1.0, size.height * 0.8);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}