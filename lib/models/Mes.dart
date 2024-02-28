class Mes{
  Map<String,double> Gastos = {};
  double Ingreso = 0;
  Map<String,double> Extras = {};
  String NMes;

  Mes(this.NMes);

  double GetGastos(){
    double ret = 0;

    for(double g in this.Gastos.values){
        ret+=g;
    }

    for(double e in this.Extras.values){
      ret+=e;
    }

    return ret;
  }

  double GetExtras(){
    double ret = 0;
    for (double extra in Extras.values){
      ret+= extra;
    }

    return ret;
  }

  double GetAhorros(){
    return this.Ingreso-GetGastos();
  }
}