class Analista {
  String name;
  String userName;
  String value;
  int idOficina;

  Analista({this.name, this.userName, this.value, this.idOficina});

  Analista.fromMap(Map<String, dynamic> analista)
      : name = analista['Name'],
        userName = analista['UserName'],
        value = analista['Value'],
        idOficina = analista['idOficina'];

  Map<String, String> toMapGet() => {
        'idOficina': idOficina.toString(),
      };
  @override
  String toString() {
    return 'Analista{name: $name, userName: $userName,value: $value}';
  }
}
