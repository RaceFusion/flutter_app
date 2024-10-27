class ExceptionHandler {
  static String parseErrorMessage(String exceptionMessage) {
    if (exceptionMessage.contains('Guest already banned')) {
      return 'Usuario ya se encuentra en la lista negra';
    } else if (exceptionMessage.contains('ID number too long')) {
      return 'Número de identificación demasiado largo';
    } else if (exceptionMessage.contains('Not a valid ID number')) {
      return 'Número de identificación no válido';
    } else if (exceptionMessage.contains('Reason cannot contain spaces')) {
      return 'El motivo no puede contener SOLO espacios';
    } else if (exceptionMessage.contains("Failed to update user")) {
      return 'Error al actualizar usuario';
    } else if (exceptionMessage.contains('User must have at least one role')) {
      return 'El usuario debe tener al menos un rol';
    } else if (exceptionMessage
        .contains('User cannot have more than 3 roles')) {
      return 'El usuario no puede tener más de 3 roles';
    } else if (exceptionMessage.contains('Username cannot be empty')) {
      return 'El nombre de usuario no puede estar vacío';
    } else if (exceptionMessage.contains('Username already exists')) {
      return 'El nombre de usuario ya existe';
    } else if (exceptionMessage.contains('User not found')) {
      return 'Usuario no encontrado';
    } else if (exceptionMessage.contains('User already banned')) {
      return 'Usuario ya se encuentra en la lista negra';
    } else if (exceptionMessage.contains('User not found')) {
      return 'Usuario no encontrado';
    } else if (exceptionMessage.contains('An unexpected error occurred')) {
      return 'Error inesperado, por favor intente de nuevo';
    } else if (exceptionMessage.contains('ID number too short')) {
      return 'Documento de identidad debe contener al menos 8 dígitos';
    } else {
      return 'Error inesperado, por favor intente de nuevo';
    }
  }
}
