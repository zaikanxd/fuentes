import 'package:microbank_app/utils/constans.dart';

class Session {
  int officeId;
  String officeName;
  int aplicacionId;
  String aplicacionName;
  int roleId;
  String roleName;
  int userId;
  String userName;
  DateTime dateCreation;
  String nomApellidos;
  int empresaId;
  String empresaName;
  String description;

  Session(
      {this.officeId,
      this.officeName,
      this.aplicacionId,
      this.aplicacionName,
      this.roleId = 0,
      this.roleName,
      this.userId,
      this.userName,
      this.dateCreation,
      this.nomApellidos,
      this.empresaId = 1,
      this.empresaName,
      this.description});

  Session.fromMap(Map<String, dynamic> session)
      : officeId = session['OfficeID'],
        officeName = session['OfficeName'],
        aplicacionId = session['AplicacionID'],
        aplicacionName = session['AplicacionName'],
        roleId = session['RoleID'],
        roleName = session['RoleName'],
        userId = session['UserID'],
        userName = session['UserName'],
        dateCreation = session['DateCreation'] != null
            ? DateTime.parse(session['DateCreation'])
            : null,
        nomApellidos = session['nomApellidos'],
        empresaId = session['EmpresaID'],
        empresaName = session['EmpresaName'],
        description = session['Description'];

  Session.fromMapStorage(Map<String, dynamic> session)
      : officeId = int.parse(session['officeId']),
        officeName = session['officeName'],
        aplicacionId = int.parse(session['aplicacionId']),
        aplicacionName = session['AplicacionName'],
        roleId = int.parse(session['roleId']),
        roleName = session['roleName'],
        userId = int.parse(session['userId']),
        userName = session['userName'],
        dateCreation = session['dateCreation'] != null
            ? DateTime.parse(session['dateCreation'])
            : null,
        nomApellidos = session['nomApellidos'],
        empresaId = int.parse(session['empresaId']),
        empresaName = session['empresaName'],
        description = session['description'];

  Map<String, String> toMapFirst(String userName) => {
        'idUsuario': userName,
        'idOficina': officeId.toString(),
        'idRol': roleId.toString()
      };

  Map<String, String> toMapSecond(String userName) => {
        'userName': userName ?? '',
        'empresaID': empresaId.toString(),
        'rolID': roleId.toString()
      };

  Map<String, String> toMapThird(String userName) => {
        'idUsuario': userName ?? '',
        'idOficina': officeId.toString(),
      };

  Map<String, String> toMapFour() => {
        'officeId': officeId.toString(),
        'officeName': officeName,
        'aplicacionId': aplicacionId.toString(),
        'aplicacionName': aplicacionName,
        'roleId': roleId.toString(),
        'roleName': roleName,
        'userId': userId.toString(),
        'userName': userName,
        'dateCreation': dateCreation.toString(),
        'nomApellidos': nomApellidos,
        'empresaId': empresaId.toString(),
        'empresaName': empresaName,
        'description': description,
      };
      
  Map<String, String> toMapLogin(
          String userName, String password, int officeId) =>
      {
        'OfficeID': officeId?.toString(),
        'AplicacionID': kAplicacionId.toString(),
        'RolID': '0',
        'UserName': userName,
        'Password': password
      };

  @override
  String toString() {
    return 'Session{officeId: $officeId, officeName: $officeName, aplicacionId: $aplicacionId, aplicacionName: $aplicacionName,roleId: $roleId,roleName: $roleName,userId:$userId,'
        'userName: $userName,dateCreation:$dateCreation,nomApellidos:$nomApellidos,empresaId:$empresaId,empresaName:$empresaName,description:$description}';
  }
}
