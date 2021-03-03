class Parametro {
  int idParametro;
  String nombre;
  String descripcion;
  String valor;

  Parametro({this.idParametro, this.nombre, this.descripcion, this.valor});

  Parametro.fromMap(Map<String, dynamic> parametro)
      : idParametro = parametro['grupoDatosDetalleID'],
        nombre = parametro['nombre'],
        descripcion = parametro['descripcion'],
        valor = parametro['valor'];

  @override
  String toString() {
    return 'Parametro{idParametro: $idParametro, nombre: $nombre, descripcion: $descripcion, valor: $valor}';
  }
}
