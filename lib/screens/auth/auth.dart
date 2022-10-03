import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/screens/register/register.dart';
import 'package:trainers_app/services/services.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _toggleAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
        _formKey.currentState!.reset();
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _formKey.currentState!.reset();
      });
    }
  }

  void _authorize(BuildContext context) {
    if (_authMode == AuthMode.Login) {
      if (_formKey.currentState!.validate()) {
        AuthService.authClient(_emailController.text, _passwordController.text)
            .then((autenticado) {
          if (autenticado) {
            Navigator.of(context).pushReplacementNamed(
              HomeScreen.routeName,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Usuario y/o contraseña erróneos.'),
              backgroundColor: Theme.of(context).errorColor,
            ));
            _formKey.currentState!.reset();
          }
        });
      }
    } else if (_authMode == AuthMode.Register) {
      Navigator.of(context).pushNamed(Register.routeName);
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
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
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
                        controller: _emailController,
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
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su contraseña';
                          } else {
                            return null;
                          }
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
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }

                            return null;
                          },
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => _authorize(context),
                        child: Text(_authMode == AuthMode.Login
                            ? "Ingresar"
                            : "Registrarse"),
                      ),
                      TextButton(
                        onPressed: _toggleAuthMode,
                        child: Text(_authMode == AuthMode.Login
                            ? "Todavía no tengo una cuenta"
                            : "Ya tengo una cuenta"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
