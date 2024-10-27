import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:karting_app/SignInScreen/API/identification_api.dart';
import 'package:karting_app/config/local_storage.dart';
import 'package:karting_app/utils/base.dart';
import 'package:karting_app/utils/page_animation.dart';
import 'package:local_auth/local_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;
  late final LocalAuthentication _localAuthentication;
  final IdentificationAPI _identificationAPI = IdentificationAPI();

  void autofill() async {
    var now = DateTime.now();
    if (await LocalStorage.containsKey("SignInDate")) {
      var signInDate =
          DateTime.parse(await LocalStorage.getString("SignInDate"));
      var difference = now.difference(signInDate).inHours;
      if (difference > 1) {
        LocalStorage.removeString("username");
        LocalStorage.removeString("password");
        LocalStorage.removeString("SignInDate");
      }

      var usernameExist = await LocalStorage.containsKey("username");
      if (usernameExist) {
        var username = await LocalStorage.getString("username");
        _usernameController.text = username;
      }
      var passwordExist = await LocalStorage.containsKey("password");
      if (passwordExist) {
        var password = await LocalStorage.getString("password");
        _passwordController.text = password;
      }
    }
  }

  Future<void> getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics =
        await _localAuthentication.getAvailableBiometrics();

    if (listOfBiometrics.isNotEmpty) {
      if (kDebugMode) {
        print(listOfBiometrics);
      }
      setState(() {});
    }
    if (!mounted) {
      return;
    }
  }

  Future<bool> isFirstTime() async {
    if (await LocalStorage.containsKey("SignInDate") &&
        await LocalStorage.containsKey("username") &&
        await LocalStorage.containsKey("password")) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> authenticateBiometric() async {
    try {
      bool isAuthenticated = await _localAuthentication.authenticate(
          localizedReason: "Please authenticate to proceed",
          options: const AuthenticationOptions(
              stickyAuth: true,
              sensitiveTransaction: true,
              biometricOnly: false));
      if (isAuthenticated) {
        autofill();
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _localAuthentication = LocalAuthentication();

    _localAuthentication.isDeviceSupported().then((isSupported) {
      if (isSupported) {
        isFirstTime().then((value) {
          if (!value) {
            authenticateBiometric();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PageAnimation pageAnimation = PageAnimation();
    return Scaffold(
      backgroundColor: const Color(0xFF161D2F),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              // Image.asset(
              //   'assets/blacklist_icon.png',
              //   width: 150,
              //   height: 150,
              // ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                onChanged: () {},
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Usuario',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su nombre de usuario';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(width: 16.0),
                                        Text("Iniciando sesión..."),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );

                            // _identificationAPI
                            //     .signIn(_usernameController.text,
                            //         _passwordController.text)
                            //     .then((value) {
                            //   Navigator.pop(context);

                            //   if (value != -1) {
                            //     LocalStorage.setString(
                            //         "username", _usernameController.text);
                            //     LocalStorage.setString(
                            //         "password", _passwordController.text);
                            //     LocalStorage.setString(
                            //         "SignInDate", DateTime.now().toString());
                            //     Navigator.push(
                            //       context,
                            //       pageAnimation
                            //           .createPageRoute(Base(id: value)),
                            //     );
                            //   } else {
                            //     setState(() {
                            //       _errorMessage =
                            //           "Usuario o contraseña incorrectos";
                            //     });
                            //   }
                            // });
                            

                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              pageAnimation.createPageRoute(
                                const Base(id: 1),
                              ),
                            );

                          } else {
                            authenticateBiometric();
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ingresar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
