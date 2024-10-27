import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:karting_app/config/local_storage.dart';
import 'package:karting_app/models/user.model.dart';
import 'package:karting_app/utils/validations/exception_handler.dart';

class BlackListApi {
  static const String baseUrl = "";
  static const String baseUrlIOS = '127.0.0.1';
  static const String path = '/api/v1/guests';
  static const String userPath = '/api/v1/users';

  static String tokenAux = '';

  Future<List<User>> getAdminUsers() async {
    try {
      tokenAux = await LocalStorage.getString('token');
      const url = '$baseUrl$userPath';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenAux',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<User> users = [];

        for (final json in jsonData) {
          final user = await User.fromJson(json);
          users.add(user);
        }

        return users;
      } else {
        throw Exception('Failed to fetch admin users: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('An unexpected error occurred: $error');
    }
  }

  Future<bool> updateAdminUserRoles(User user, String newPassword) async {
    try {
      tokenAux = await LocalStorage.getString('token');
      if (user.roles.isEmpty) {
        throw Exception('User must have at least one role');
      } else if (user.roles.length > 3) {
        throw Exception('User cannot have more than 3 roles');
      } else if (user.username.isEmpty) {
        throw Exception('Username cannot be empty');
      } else if (user.username.length > 100) {
        throw Exception('Username too long');
      } else if (user.id <= 0) {
        throw Exception('Invalid user id');
      }

      var id = user.id;
      var url = '$baseUrl$userPath/update-user/$id';

      Map<String, dynamic> requestBody = {
        'rolEnum': user.convertRolesStringToInt(),
        'newPassword': newPassword,
      };

      final response = await http.patch(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenAux',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update user roles');
      }
    } catch (error) {
      if (error is Exception && error.toString().isNotEmpty) {
        return Future.error(
            ExceptionHandler.parseErrorMessage(error.toString()));
      } else {
        return Future.error('Error inesperado, por favor intente de nuevo');
      }
    }
  }

  Future<User> getUserById(int id) async {
    try {
      // getToken();
      tokenAux = await LocalStorage.getString('token');

      var url = '$baseUrl$userPath/$id';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenAux',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        return User(id: -1, username: '', roles: []);
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error during get user by id: $error');
      }
      rethrow;
    }
  }

  Future<bool> deleteAdminUser(int id) async {
    try {
      tokenAux = await LocalStorage.getString('token');
      var url = '$baseUrl$userPath/delete-user/$id';
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenAux',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception('An unexpected error occurred while deleting: $error');
    }
  }
}
