import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:karting_app/config/local_storage.dart';

class IdentificationAPI {
  static const String baseUrl = "";
  static const String baseUrlIOS = '127.0.0.1';
  static const String path = '/api/v1/authentication';

  Future<int> signIn(String username, String password) async {
    try {
      var url = '$baseUrl$path/sign-in';
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['token'] != null && data['token'] != '') {
          await LocalStorage.removeString('token');
          await LocalStorage.setString('token', data['token']);
        }
        return data['id'] as int;
      } else {
        return -1;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error during sign-in: $error');
      }
      rethrow;
    }
  }

  Future<bool> signUp(String username, String password, List<int> roles) async {
    try {
      var url = '$baseUrl$path/sign-up';
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'username': username,
          'password': password,
          'rolEnum': roles,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to sign up');
      }
    } catch (error) {
      throw Exception('An unexpected error occurred while signing up: $error');
    }
  }
}
