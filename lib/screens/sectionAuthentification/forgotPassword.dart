import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/services/user_service_API.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      UserServiceApi().updatePassword(email, password);
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Mot de passe réinitialisé'),
            content: const Text('Vous pouvez maintenant vous reconnecter'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mot de passe oublié'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  } else if (!value.contains('@')) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration:
                    const InputDecoration(labelText: 'Nouveau mot de passe'),
                validator: (value) {
                  final specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 8) {
                    return 'Password doit contenir au moins 8 caractères';
                  } else if (!specialChars.hasMatch(value)) {
                    return 'Le mot de passe doit contenir au moins un caractère spécial';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Réinitialiser le mot de passe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
