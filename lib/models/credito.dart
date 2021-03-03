class Credito {
  int idCredito;
  int diasAtraso;
  String formaPago;
  String telefono;
  String cuotaPagada;
  double cuotaDiaria;
  double deudaTotal;
  double deudaCuotas;
  Credito(
      {this.idCredito,
      this.diasAtraso,
      this.cuotaDiaria,
      this.cuotaPagada,
      this.deudaCuotas,
      this.deudaTotal,
      this.telefono,
      this.formaPago});

  Credito.fromMap(Map<String, dynamic> credito)
      : idCredito = credito['idCredito'],
        diasAtraso = credito['nDiasAtraso'],
        cuotaDiaria = credito['nCuotaDiaria'],
        deudaCuotas = credito['nDeudaCuotas'],
        deudaTotal = credito['nDeudaTotal'],
        formaPago = credito['cFormaPago'],
        cuotaPagada = credito['cCuotaPagada'],
        telefono = credito['cTelefono'];

  Map<String, String> toMapGet() => {
        'idCredito': idCredito.toString(),
      };
  @override
  String toString() {
    return 'Credito{idCredito: $idCredito, diasAtraso: $diasAtraso,cuotaDiaria: $cuotaDiaria,cuotaPagada: $cuotaPagada,deudaCuotas:$deudaCuotas,deudaTotal: $deudaTotal,telefono:$telefono}';
  }
}
