import 'package:flutter/material.dart';
import '../home_screen/home_screen.dart';

enum AuthMode { Login, Register }

class Auth extends StatefulWidget {
  static const routeName = '/auth';
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  AuthMode _authMode = AuthMode.Login;
  final _formKey = GlobalKey<FormState>();

  void _toggleAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void _homeScreen(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed(
        HomeScreen.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          Center(
            child: Card(
              child: Form(
                key: _formKey,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 320,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  width: deviceSize.width * 0.75,
                  height: 391,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Correo',
                          suffixIcon: Icon(Icons.alternate_email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Debe ingresar un correo';
                          }

                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);

                          if (!emailValid) {
                            return 'Ingrese un correo válido';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          suffixIcon: Icon(Icons.key),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Ingrese su contraseña';
                          else
                            return null;
                        },
                      ),
                      if (_authMode == AuthMode.Login)
                        const TextButton(
                          onPressed: null,
                          child: Text('¿Olvidaste tu contraseña?'),
                        ),
                      if (_authMode == AuthMode.Register)
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Confirmar contraseña',
                            suffixIcon: Icon(Icons.key),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Ingrese la contraseña nuevamente';
                          },
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => _homeScreen(context),
                        child: Text(
                            '${_authMode == AuthMode.Login ? "Ingresar" : "Registrarse"}'),
                      ),
                      TextButton(
                        onPressed: _toggleAuthMode,
                        child: Text(
                            '${_authMode == AuthMode.Login ? "Todavía no tengo una cuenta" : "Ya tengo una cuenta"}'),
                      )
                    ],
                  ),
                ),
              ),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
