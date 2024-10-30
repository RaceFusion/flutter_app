class RoleAppToEndpoint {
  static List<int> getRoleAppToEndpoint(List<String> roles) {
    
    List<int> rolesInt = roles.map((role) {
      switch (role) {
        case 'Administrador':
          return 3;
        case 'Driver':
          return 1;
        case 'Team':
          return 2;
        default:
          return -1;
      }
    }).toList();
    return rolesInt;
  }
}
