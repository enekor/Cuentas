import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyPattern extends CustomPainter {

  final time = DateTime.now().millisecondsSinceEpoch;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random();
    final paint = Paint();

    //circulo
    paint.color = const Color.fromRGBO(255, 230, 230, 1);
    canvas.drawCircle(Offset(random.nextDouble()*size.width, random.nextDouble()*size.height), 100, paint);

    paint.color = const Color.fromRGBO(255, 175, 209, 1);
    canvas.drawCircle(Offset(random.nextDouble()*size.width, random.nextDouble()*size.height), 75, paint);

    paint.color = const Color.fromRGBO(173, 136, 198, 1);
    canvas.drawCircle(Offset(random.nextDouble()*size.width, random.nextDouble()*size.height), 50, paint);

    paint.color = const Color.fromRGBO(116, 105, 182, 1);
    canvas.drawCircle(Offset(random.nextDouble()*size.width, random.nextDouble()*size.height), 40, paint);

    paint.color = const Color.fromRGBO(190, 173, 250, 1);

    
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