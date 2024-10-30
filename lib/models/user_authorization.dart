class UserAuthotization{
  int id = 0;
  List<dynamic> roles = [];

  UserAuthotization({
    required this.id,
    required this.roles,
  });


  static Future<UserAuthotization> fromJson(Map<String, dynamic> json) async {
    final id = json['id'] as int?;
    final roles = json['roles'] as List<dynamic>?;
    if (id == null || roles == null) {
      throw const FormatException('Missing required fields in JSON');
    }
    return UserAuthotization(
      id: id,
      roles: roles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roles': roles,
    };
  }

  List<String> convertRolesIntToString(){
    final List<String> rolesString = [];
    for (final role in roles){
      if (role == 1){
        rolesString.add('Driver');
      } else if (role == 2){
        rolesString.add('Team');
      } else if (role == 3){
        rolesString.add('Administrador');
      }
    }
    return rolesString;
  }
}