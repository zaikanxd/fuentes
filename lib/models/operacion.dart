class Operacion {
  int idKardex;
  double monto;
  String operacion;
  String oficina;
  String usuario;
  String fecha;
  String rutaImagen;
  String numCheque;

  // Extorno

  String motivo;
  String comentario;
  String idUser;

  Operacion(
      {this.idKardex,
      this.oficina,
      this.usuario,
      this.fecha,
      this.monto,
      this.operacion,
      this.rutaImagen,
      this.numCheque,
      this.idUser,
      this.comentario,
      this.motivo});

  Operacion.fromMap(Map<String, dynamic> operacion)
      : idKardex = operacion['idKardex'],
        monto = operacion['nMonto'],
        operacion = operacion['cOperacion'],
        oficina = operacion['cOficina'],
        usuario = operacion['cUsuario'],
        fecha = operacion['dFecha'],
        numCheque = operacion['cNumCheque'],
        rutaImagen = operacion['imagen'];

  Map<String, String> toMapGet() => {
        'idKardex': idKardex.toString(),
      };

  Map<String, String> toMapExtornar() => {
        'idKardex': idKardex.toString(),
        'idMotivo': motivo,
        'cComentario': comentario,
        'idUser': idUser
      };
  @override
  String toString() {
    return 'Operacion{idKardex: $idKardex, monto: $monto, operacion: $operacion, '
        'oficina: $oficina,usuario: $usuario,fecha: $fecha, numCheque: $numCheque ,rutaImagen:$rutaImagen}';
  }
}
