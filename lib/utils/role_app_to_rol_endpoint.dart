class RoleAppToEndpoint {
  static List<int> getRoleAppToEndpoint(List<String> roles) {
    
    List<int> rolesInt = roles.map((role) {
      switch (role) {
        case 'Administrador':
          return 3;
        case 'Escritor':
          return 1;
        case 'Lector':
          return 2;
        default:
          return -1;
      }
    }).toList();
    return rolesInt;
  }
}
