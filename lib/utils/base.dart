import 'package:flutter/material.dart';
import 'package:karting_app/SignInScreen/API/blacklist_api.dart';
import 'package:karting_app/models/user.model.dart';
import 'package:karting_app/utils/bottom_nav.dart';
import 'package:karting_app/utils/routes.dart';

class Base extends StatefulWidget {
  final int id;
  const Base({super.key, required this.id});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  Map<String, int> currentIndexMap = {
    'Administrador': 0,
    'Escritor': 0,
    'Lector': 0
  };
  late List<String> roles = [];
  late User loggedUser;
  BlackListApi identificationAPI = BlackListApi();

  @override
  void initState() {
    super.initState();
    _getUserRoles();
  }

  void _getUserRoles() async {
    //loggedUser = await identificationAPI.getUserById(widget.id);

    // create fake user
    loggedUser = User(
      id: 1,
      username: 'admin',
      roles: [1, 2, 3],
    );


    setState(() {
      roles = loggedUser.convertRolesIntToString();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (roles.contains('Administrador')) {
      return MaterialApp(
        home: Scaffold(
          body: Routes(
            index: currentIndexMap['Administrador'] ?? 0,
            roles: roles,
          ),
          bottomNavigationBar: BottomNav(
            currentIndex: (i) {
              setState(() {
                currentIndexMap['Administrador'] = i;
              });
            },
            roles: roles,
          ),
        ),
      );
    } else if (roles.contains('Escritor')) {
      return MaterialApp(
        home: Scaffold(
          body: Routes(
            index: currentIndexMap['Escritor'] ?? 0,
            roles: roles,
          ),
          bottomNavigationBar: BottomNav(
            currentIndex: (i) {
              setState(() {
                currentIndexMap['Escritor'] = i;
              });
            },
            roles: roles,
          ),
        ),
      );
    } else if (roles.contains('Lector')) {
      return MaterialApp(
        home: Scaffold(
          body: Routes(
            index: currentIndexMap['Lector'] ?? 0,
            roles: roles,
          ),
          bottomNavigationBar: BottomNav(
            currentIndex: (i) {
              setState(() {
                currentIndexMap['Lector'] = i;
              });
            },
            roles: roles,
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          color: Color.fromRGBO(90, 105, 143, 1),
        )),
      );
    }
  }
}
