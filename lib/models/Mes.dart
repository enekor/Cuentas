class Mes{
  Map<String,double> Gastos;
  double Ingreso;
  Map<String,double> Extras;

  Mes(this.Ingreso,this.Gastos,this.Extras);

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

  double GetAhorros(){
    return this.Ingreso-GetGastos();
  }
}