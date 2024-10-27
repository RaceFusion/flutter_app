class User {
  final int id;
  final String username;
  List<dynamic> roles;
  DateTime? creationDate;

  User({required this.id, required this.username, required this.roles, this.creationDate});
  

  static Future<User> fromJson(Map<String, dynamic> json) async {
    final id = json['id'] as int?;
    final username = json['username'] as String?;
    final roles = json['rolEnum'] as List<dynamic>?;
    final creationDateStr = json['createdAt'] as String?;
    final creationDate =
        creationDateStr != null ? DateTime.parse(creationDateStr) : null;

    if (id == null || username == null || roles == null || creationDate == null) {
      throw const FormatException('Missing required fields in JSON');
    }

    return User(
      id: id,
      username: username,
      roles: roles,
      creationDate: creationDate,      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'rolEnum': roles,
      'createdAt': creationDate?.toIso8601String(),
    };
  }
  Map<String, dynamic> rolesToJson() {
    return {
      'rolEnum': roles,
    };
  }

  List<int> convertRolesStringToInt(){
    final List<int> rolesInt = [];
    for (final role in roles){
      if (role == 'Escritor'){
        rolesInt.add(1);
      } else if (role == 'Lector'){
        rolesInt.add(2);
      } else if (role == 'Administrador'){
        rolesInt.add(3);
      }
    }
    return rolesInt;
  }

  List<String> convertRolesIntToString(){
    final List<String> rolesString = [];
    for (final role in roles){
      if (role == 1){
        rolesString.add('Escritor');
      } else if (role == 2){
        rolesString.add('Lector');
      } else if (role == 3){
        rolesString.add('Administrador');
      }
    }
    return rolesString;
  }
}
