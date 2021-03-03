class Deposito {
  int idKardex;
  String banco;
  String importe;
  String hora;
  String bancoName;
  String officeName;
  String idUsuReg;
  String fechaVoucher;
  String fecha;
  String nroOperacion;

  // Parametros

  String idBanco;
  String idOficina;
  String imageUrl;

  Deposito(
      {this.idKardex,
      this.banco,
      this.importe,
      this.hora,
      this.bancoName,
      this.officeName,
      this.idUsuReg,
      this.fechaVoucher,
      this.fecha,
      this.nroOperacion,
      this.idBanco,
      this.idOficina,
      this.imageUrl});

  Deposito.fromMap(Map<String, dynamic> deposito)
      : idKardex = deposito['idKardex'],
        banco = deposito['cBanco'],
        importe = (deposito['nImporte'] as double).toStringAsFixed(2),
        hora = deposito['cHora'],
        bancoName = deposito['bancoName'],
        officeName = deposito['officeName'],
        idUsuReg = deposito['idUsuReg'],
        fechaVoucher = deposito['dFechaVoucher'],
        fecha = deposito['dFecha'],
        nroOperacion = deposito['cNroOperacion'],
        imageUrl = deposito['imagen'];

  Map<String, String> toMapCreate() => {
        'dFecha': fecha,
        'idBanco': idBanco,
        'cNroOperacion': nroOperacion,
        'nImporte': importe,
        'idUsuReg': idUsuReg,
        'dFechaVoucher': fechaVoucher,
        'idOficina': idOficina,
        'imagenstring': imageUrl,
      };

  Map<String, String> toMapExtorno() => {
        'idKardex': idKardex.toString(),
        'idUser': idUsuReg,
      };

  Map<String, String> toMapGet() => {
        'idKardex': idKardex.toString(),
      };
  @override
  String toString() {
    return 'Deposito{idKardex: $idKardex, banco: $banco, importe: $importe, hora: $hora,bancoName: $bancoName,idUsuReg: $idUsuReg,fechaVoucher:$fechaVoucher,fecha:$fecha'
        'nroOperacion: $nroOperacion}';
  }
}
