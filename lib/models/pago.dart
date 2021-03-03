class Pago {
  int idCredito;
  int idOficinaOpe;
  double monto;
  double mora;
  int tipo;
  int codOperacion;
  int idKardexHijo;
  int valuta;
  String idOpcion1;
  String idOpcion2;
  String idBanco;
  String idUser;
  String fecha;
  String numCheque;
  String fechaVoucher;
  String imagen;

  Pago(
      {this.idCredito,
      this.idOficinaOpe,
      this.fecha,
      this.monto,
      this.mora,
      this.tipo,
      this.codOperacion,
      this.idBanco,
      this.numCheque,
      this.fechaVoucher,
      this.idKardexHijo,
      this.valuta,
      this.idOpcion1,
      this.idOpcion2,
      this.imagen,
      this.idUser});

  Map<String, dynamic> toMap() => {
        'idCredito': idCredito,
        'idUser': idUser,
        'idOficinaOpe': idOficinaOpe,
        'pdFecha': fecha,
        'pnMonto': monto,
        'pnMora': mora,
        'pbTipo': tipo,
        'idCodOperacion': codOperacion,
        'idBanco': idBanco,
        'cNumCheque': numCheque,
        'dFechaVoucher': fechaVoucher,
        'idKardexHijo': idKardexHijo,
        'bValuta': valuta,
        'idOpcion1': idOpcion1,
        'idOpcion2': idOpcion2,
        'imagen': imagen,
      };

  @override
  String toString() {
    return 'Pago{idCredito: $idCredito,idUser:$idUser, idOficinaOpe: $idOficinaOpe,fecha: $fecha,monto: $monto,mora:$mora,tipo: $tipo,codOperacion:$codOperacion,idBanco:$idBanco,'
        'numCheque:$numCheque,fechaVoucher:$fechaVoucher,idKardexHijo:$idKardexHijo,valuta:$valuta,idOpcion1:$idOpcion1,idOpcion2:$idOpcion2,imagen:$imagen}';
  }
}
