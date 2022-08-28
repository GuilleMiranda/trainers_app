import 'package:flutter/material.dart';
import '../auth/auth.dart';

class Register extends StatelessWidget {
  static const routeName = '/register';
  const Register({super.key});

  void auth(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Auth(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Registration screen'),
            TextButton(
              onPressed: () => auth(context),
              child: Text('Ya tengo una cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
