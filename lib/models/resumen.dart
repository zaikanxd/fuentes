class Resumen {
  String clientesAsignados;
  String clientesConPagoSemanal;
  String clientesConPagoDiario;
  String clientesAlDia;
  String clientesConUnaCuotaPorPagar;
  String clientesConDosCuotasPorPagar;
  String clientesConTresCuotasPorPagar;
  String clientesQuePagaronHoy;
  String diferenciaEntreCobradoYDepositado;
  String depositoEnBancoPorCobroDelDia;
  String totalEfectivoADepositarEnBanco;
  String pagoEnEfectivo;
  String pagoDeMorosidadEnEfectivo;
  String pagosViaTransferenciaEnBanco;
  String pagosDeMorosidadViaTransferencia;
  String pagoTotalesIncluyendoMora;

  Resumen(
      {this.clientesAsignados,
      this.clientesConPagoSemanal,
      this.clientesConPagoDiario,
      this.clientesAlDia,
      this.clientesConUnaCuotaPorPagar,
      this.clientesConDosCuotasPorPagar,
      this.clientesConTresCuotasPorPagar,
      this.clientesQuePagaronHoy,
      this.diferenciaEntreCobradoYDepositado,
      this.depositoEnBancoPorCobroDelDia,
      this.totalEfectivoADepositarEnBanco,
      this.pagoEnEfectivo,
      this.pagoDeMorosidadEnEfectivo,
      this.pagosViaTransferenciaEnBanco,
      this.pagosDeMorosidadViaTransferencia,
      this.pagoTotalesIncluyendoMora});

  Resumen.fromListMap(List<dynamic> resumen)
      : clientesAsignados = resumen[0]['cImporte'],
        clientesConPagoSemanal = resumen[1]['cImporte'],
        clientesConPagoDiario = resumen[2]['cImporte'],
        clientesAlDia = resumen[4]['cImporte'],
        clientesConUnaCuotaPorPagar = resumen[5]['cImporte'],
        clientesConDosCuotasPorPagar = resumen[6]['cImporte'],
        clientesConTresCuotasPorPagar = resumen[7]['cImporte'],
        clientesQuePagaronHoy = resumen[9]['cImporte'],
        diferenciaEntreCobradoYDepositado = resumen[11]['cImporte'],
        depositoEnBancoPorCobroDelDia = resumen[13]['cImporte'],
        totalEfectivoADepositarEnBanco = resumen[14]['cImporte'],
        pagoEnEfectivo = resumen[15]['cImporte'],
        pagoDeMorosidadEnEfectivo = resumen[16]['cImporte'],
        pagosViaTransferenciaEnBanco = resumen[17]['cImporte'],
        pagosDeMorosidadViaTransferencia = resumen[18]['cImporte'],
        pagoTotalesIncluyendoMora = resumen[19]['cImporte'];
  @override
  String toString() {
    return 'Resumen{clientesAsignados: $clientesAsignados, clientesConPagoSemanal: $clientesConPagoSemanal, clientesConPagoDiario: $clientesConPagoDiario,clientesAlDia:$clientesAlDia,'
        'clientesConUnaCuotaPorPagar:$clientesConUnaCuotaPorPagar,clientesConDosCuotasPorPagar:$clientesConDosCuotasPorPagar,clientesConTresCuotasPorPagar:$clientesConTresCuotasPorPagar,'
        'clientesQuePagaronHoy: $clientesQuePagaronHoy,diferenciaEntreCobradoYDepositado:$diferenciaEntreCobradoYDepositado,depositoEnBancoPorCobroDelDia:$depositoEnBancoPorCobroDelDia,'
        'totalEfectivoADepositarEnBanco:$totalEfectivoADepositarEnBanco,pagoEnEfectivo:$pagoEnEfectivo,pagoDeMorosidadEnEfectivo:$pagoDeMorosidadEnEfectivo,pagosViaTransferenciaEnBanco:$pagosViaTransferenciaEnBanco,'
        'pagosDeMorosidadViaTransferencia:$pagosDeMorosidadViaTransferencia,pagoTotalesIncluyendoMora:$pagoTotalesIncluyendoMora}';
  }
}
