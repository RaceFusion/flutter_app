import 'package:flutter/material.dart';
import 'package:karting_app/presentation/placeholder.dart';
import 'package:karting_app/presentation/placeholder2.dart';
import 'package:karting_app/presentation/user_role_managment.dart';

class Routes extends StatelessWidget {
  final int index;
  final List<String> roles;

  const Routes({super.key, required this.index, required this.roles});

  @override
  Widget build(BuildContext context) {
    List<Widget> routes = [];

    if (roles.contains('Administrador')) {
      routes.add(const PlaceHolder1());
      routes.add(const PlaceHolder2());
      routes.add(const UserRoleManagement());
    }

    if (roles.contains('Driver')) {
      routes.add(const PlaceHolder1());
    }

    if (roles.contains('Team')) {
      routes.add(const PlaceHolder2());
    }

    if (index < routes.length) {
      return routes[index];
    } else {
      return Container();
    }
  }
}
