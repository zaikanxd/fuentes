class SelectOption {
  int idSelectOption;
  int idGroup;
  String nombre;
  String valor;

  SelectOption({this.idSelectOption, this.idGroup, this.nombre, this.valor});

  static const idGroupBancos = 1017;
  static const idGroupDificultad = 1018;
  static const idGroupNegocios = 1019;
  static const idGroupMotivosExtorno = 1021;

  SelectOption.fromMap(Map<String, dynamic> grupoDatosDetalle)
      : idSelectOption = grupoDatosDetalle['grupoDatosDetalleID'],
        idGroup = grupoDatosDetalle['grupoDatosID'],
        nombre = grupoDatosDetalle['nombre'],
        valor = grupoDatosDetalle['valor'];

  @override
  String toString() {
    return 'SelectOption{idSelectOption: $idSelectOption, idGroup: $idGroup, nombre: $nombre, valor: $valor}';
  }
}
