class Oficina {
  int id;
  String name;
  String direccion;
  String referencia;
  String coordenadas;
  String descripcion;
  bool status;
  String userCreation;
  String dateCreation;
  String userLastUpdate;
  String dateLastUpdate;
  int empresaID;
  String empresaName;

  Oficina(
      {this.id,
      this.name,
      this.direccion,
      this.referencia,
      this.coordenadas,
      this.descripcion,
      this.status,
      this.userCreation,
      this.dateCreation,
      this.userLastUpdate,
      this.dateLastUpdate,
      this.empresaID,
      this.empresaName});

  Oficina.fromMap(Map<String, dynamic> office)
      : id = office['ID'],
        name = office['Name'],
        direccion = office['Direccion'],
        referencia = office['Referencia'],
        coordenadas = office['Coordenadas'],
        descripcion = office['Descripcion'],
        status = office['Status'],
        userCreation = office['UserCreation'],
        dateCreation = office['DateCreation'],
        userLastUpdate = office['UserLastUpdate'],
        dateLastUpdate = office['DateLastUpdate'],
        empresaID = office['empresaID'],
        empresaName = office['empresaName'];

  @override
  String toString() {
    return 'Oficina{id: $id, name: $name, direccion: $direccion, referencia: $referencia,coordenadas: $coordenadas,descripcion: $descripcion,status:$status,'
        'userCreation: $userCreation,dateCreation:$dateCreation,userLastUpdate:$userLastUpdate,dateLastUpdate:$dateLastUpdate,empresaID:$empresaID,empresaName:$empresaName}';
  }
}
