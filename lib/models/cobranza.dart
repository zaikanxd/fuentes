enum TipoCobranza { pendiente, realizada }

class Cobranza {
  int idKardex;
  int idCredito;
  int diasAtraso;
  String nombres;
  String hora;
  double montoPagado;
  double montoDeuda;

  Cobranza(
      {this.nombres,
      this.hora,
      this.montoPagado,
      this.idCredito,
      this.diasAtraso,
      this.montoDeuda});

  Cobranza.fromMap(Map<String, dynamic> cliente)
      : idKardex = cliente['idKardex'],
        nombres = cliente['cNombres'],
        hora = cliente['cHora'],
        montoPagado = cliente['nMontoPagado'],
        idCredito = cliente['idCredito'],
        diasAtraso = cliente['nDiasAtraso'],
        montoDeuda = cliente['nMontoDeuda'];

  @override
  String toString() {
    return 'Cobranza{nombres: $nombres, hora: $hora,montoPagado: $montoPagado,idCredito: $idCredito,diasAtraso:$diasAtraso,'
        'montoDeuda: $montoDeuda}';
  }
}
