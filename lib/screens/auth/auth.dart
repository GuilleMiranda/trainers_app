import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/session.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = '';
    _passwordController.text = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          Center(
            child: _authCard(context),
          ),
        ],
      ),
    );
  }

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
    if (_formKey.currentState!.validate()) {
      if (_authMode == AuthMode.Login) {
        AuthService.authClient(_emailController.text, _passwordController.text)
            .then((id) {
          if (id != -1) {
            ClientService.getClient(id).then((client) {
              Provider.of<Session>(context, listen: false).setClient(client!);

              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Usuario y/o contraseña erróneos.'),
              backgroundColor: Theme.of(context).errorColor,
            ));
            _emailController.clear();
            _passwordController.clear();
            _formKey.currentState!.reset();
          }
        }).onError((error, stackTrace) {
          _emailController.clear();

          _passwordController.clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Algo salió mal. Intentá de nuevo.')));

          Navigator.of(context).reassemble();
        });
      } else if (_authMode == AuthMode.Register) {
        AuthService.validateEmail(_emailController.text).then((value) {
          if (value) {
            Navigator.of(context).pushNamed(Register.routeName,
                arguments: Cliente.onRegister(
                    _emailController.text, _passwordController.text));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).errorColor,
                content: const Text(
                    'El correo ya está registrado. Intentá con otro.')));
          }
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).errorColor,
              content: const Text('Algo salió mal.')));
        });
      }
    }
  }

  String? _emailValidator(String? value) {
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
  }

  Widget _emailForm() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Correo',
        suffixIcon: Icon(Icons.alternate_email),
      ),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: _emailValidator,
    );
  }

  String? _contrasenaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese su contraseña';
    } else {
      return null;
    }
  }

  String? _confirmarContrasenaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese la contraseña nuevamente';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  Widget _contrasenaForm(String label, Function(String) validator,
      TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.key),
      ),
      controller: controller,
      obscureText: true,
      validator: (value) => validator(value as String),
    );
  }

  Widget _authCard(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
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
              _emailForm(),
              _contrasenaForm(
                'Contraseña',
                _contrasenaValidator,
                _passwordController,
              ),
              if (_authMode == AuthMode.Login)
                const TextButton(
                  onPressed: null,
                  child: Text('¿Olvidaste tu contraseña?'),
                ),
              if (_authMode == AuthMode.Register)
                _contrasenaForm(
                  'Confirmar contraseña',
                  _confirmarContrasenaValidator,
                  _confirmPasswordController,
                ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => _authorize(context),
                child: Text(
                    _authMode == AuthMode.Login ? "Ingresar" : "Comenzar registro"),
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
    );
  }
}
