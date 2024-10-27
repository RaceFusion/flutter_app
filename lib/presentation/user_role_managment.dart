import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:karting_app/SignInScreen/API/identification_api.dart';
import 'package:karting_app/models/user.model.dart';
import 'package:karting_app/utils/validations/error_handler.dart';
import 'package:karting_app/widgets/circle_icon_button.dart';
import 'package:karting_app/widgets/role_check_box.dart';

import '../SignInScreen/API/blacklist_api.dart';

class UserRoleManagement extends StatefulWidget {
  const UserRoleManagement({super.key});

  @override
  State<UserRoleManagement> createState() => _UserRoleManagementState();
}

class _UserRoleManagementState extends State<UserRoleManagement> {
  bool _isMounted = false;
  bool _isCreatingUser = false;

  final Map<int, String> roleDisplayNames = {
    1: 'Escritor',
    2: 'Lector',
    3: 'Administrador',
  };

  late List<List<bool>> userCheckedRoles;
  List<User> allUsers = [];
  List<User> displayedUsers = [];
  final BlackListApi _blackListApi = BlackListApi();
  final IdentificationAPI _identificationAPI = IdentificationAPI();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _isMounted = true;

    _initializeData();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _initializeData() async {
    try {
      _isLoading = true;
      final List<User> users = await _blackListApi.getAdminUsers();
      if (_isMounted) {
        setState(() {
          allUsers = users;
          userCheckedRoles = allUsers.map((user) {
            return [1, 2, 3].map((role) => user.roles.contains(role)).toList();
          }).toList();
          displayedUsers = List.from(allUsers);
          _isLoading = false;
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error initializing data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
              ],
              onChanged: (value) {
                setState(() {
                  displayedUsers = allUsers
                      .where((user) => user.username
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar usuario',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if(_isLoading) return;

              _showCreateUserDialog();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green[600],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text('Crear Usuario'),
              ],
            ),
          ),
          _isLoading
              ? const Center(
                  child: Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Gap(8.0),
                        Text('Cargando usuarios...'),
                      ],
                    ),
                  ),
                ))
              : Expanded(
                  child: ListView.builder(
                    itemCount: displayedUsers.length,
                    itemBuilder: (context, index) {
                      final User user = displayedUsers[index];

                      return ListTile(
                          title: Text(user.username),
                          subtitle: Text(
                            'Roles: ${user.roles.map((role) => roleDisplayNames[role] ?? role).join(', ')}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleIconButton(
                                icon: Icons.edit,
                                onPressed: () {
                                  _showRolesDialog(user, index);
                                },
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 16.0),
                              CircleIconButton(
                                icon: Icons.delete,
                                onPressed: () {
                                  _showDeleteUserDialog(context, user);
                                },
                                color: Colors.red,
                              ),
                            ],
                          ),
                          onTap: () {
                            _openRecordInfoDialog(user);
                          });
                    },
                  ),
                ),
        ],
      ),
    );
  }

  void _showRolesDialog(User user, int userIndex) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    // controller
    final TextEditingController _passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar perfil de ${user.username}'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(5),
                  TextFormField(
                    enabled: true,
                    decoration: const InputDecoration(
                      labelText: 'Nueva contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _passwordController,
                  ),
                  const Gap(4),
                  const Text(
                    'Selecciona los roles:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  for (int i = 0; i < roleDisplayNames.length; i++)
                    RoleCheckbox(
                      roleName: roleDisplayNames[i + 1]!,
                      initialValue: userCheckedRoles[userIndex][i],
                      onChanged: (value) {
                        setState(() {
                          userCheckedRoles[userIndex][i] = value;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  User copyUser = user;
                  List<String> updatedRoles = [];
                  for (int i = 0; i < userCheckedRoles[userIndex].length; i++) {
                    if (userCheckedRoles[userIndex][i]) {
                      updatedRoles.add(roleDisplayNames[i + 1]!);
                    }
                  }
                  user.roles = updatedRoles;
                  _blackListApi
                      .updateAdminUserRoles(
                          user, _passwordController.text.toString())
                      .then((value) {
                    if (value) {
                      Navigator.of(context).pop();
                      ErrorHandler.showSuccessDialog(context, user.username);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al actualizar los roles'),
                        ),
                      );
                    }
                  }).catchError((error) {
                    user.roles = copyUser.roles;
                    Navigator.of(context).pop();
                    ErrorHandler.showFailureDialog(context, error.toString());
                    _initializeData();

                    return;
                  });

                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green[600],
              ),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateUserDialog() {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    List<bool> newRoles = [false, false, false];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear Nuevo Usuario'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    maxLength: 100,
                    decoration:
                        const InputDecoration(labelText: 'Nombre de usuario'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese un nombre de usuario válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese una contraseña válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Selecciona los roles:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  for (int i = 0; i < roleDisplayNames.length; i++)
                    RoleCheckbox(
                      roleName: roleDisplayNames.values.elementAt(i),
                      initialValue: newRoles[i],
                      onChanged: (value) {
                        setState(() {
                          newRoles[i] = value;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  List<int> selectedRoles = [];

                  for (int i = 0; i < newRoles.length; i++) {
                    if (newRoles[i]) {
                      selectedRoles.add(roleDisplayNames.keys.elementAt(i));
                    }
                  }

                  setState(() {
                    _isCreatingUser = true;
                  });

                  _identificationAPI
                      .signUp(
                        usernameController.text,
                        passwordController.text,
                        selectedRoles,
                      )
                      .then((value) => {
                            if (value)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Usuario creado correctamente'),
                                  ),
                                ),
                                setState(() {
                                  _initializeData();
                                }),
                                Navigator.of(context).pop(),
                              }
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Error al crear el usuario'),
                                  ),
                                ),
                              }
                          })
                      .whenComplete(() => {
                            if (_isMounted)
                              {
                                setState(() {
                                  _isCreatingUser = false;
                                })
                              }
                          });
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green[600],
              ),
              child: _isCreatingUser
                  ? const CircularProgressIndicator()
                  : const Text('Crear Usuario'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteUserDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('El usuario ha sido eliminado'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre: ${user.username}'),
              Text(
                'Roles: ${user.roles.map((role) => roleDisplayNames[role] ?? role).join(', ')}',
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // delete user
                    _blackListApi.deleteAdminUser(user.id).then((value) => {
                          if (value == true)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Usuario eliminado correctamente'),
                                ),
                              ),
                              setState(() {
                                allUsers.remove(user);
                                displayedUsers.remove(user);
                              }),
                              Navigator.of(context).pop()
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al eliminar el usuario'),
                                ),
                              ),
                            }
                        });
                    setState(() {
                      allUsers.remove(user);
                      displayedUsers.remove(user);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _openRecordInfoDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información del Registro',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(90, 105, 143, 1),
              )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('Nombre', user.username),
              const SizedBox(height: 8.0),
              _buildInfoRow('Fecha de creación', user.creationDate as Object),
              const SizedBox(height: 8.0),
              _buildInfoRow('Roles', user.roles),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
              ),
              child:
                  const Text('Aceptar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildInfoRow(String label, Object value) {
  String formattedValue = '';

  if (value is String) {
    formattedValue = value[0].toUpperCase() + value.substring(1);
  } else if (value is DateTime) {
    formattedValue = DateFormat('HH:mm - dd-MM-yyyy').format(value);
  } else if (value is List<dynamic>) {
    final Map<int, String> roleDisplayNames = {
      1: 'Escritor',
      2: 'Lector',
      3: 'Administrador',
    };
    formattedValue =
        value.map((role) => roleDisplayNames[role] ?? role).join(', ');
  }

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$label:',
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(width: 8.0),
      Flexible(
        child: Text(
          formattedValue,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),
    ],
  );
}
