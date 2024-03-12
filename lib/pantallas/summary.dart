import 'package:cuentas_android/models/Cuenta.dart';
import 'package:cuentas_android/pattern/pattern.dart';
import 'package:cuentas_android/pattern/positions.dart';
import 'package:cuentas_android/values.dart';
import 'package:cuentas_android/widgets/summaryView.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatefulWidget {
  Cuenta cuenta;
  SummaryPage({Key? key, required this.cuenta}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState(cuenta);
}

class _SummaryPageState extends State<SummaryPage> {
  late Cuenta c;
  _SummaryPageState(this.c);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        positions().ChangePositions(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);
      },
      child: Scaffold(
          body: CustomPaint(
            painter: MyPattern(context),
            child: Center(
              child: SingleChildScrollView(
                child: summaryView(c.Meses,context)
              ),
            )
          )
      ),
    );
  }
}