
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/UI/themes/boutonRetour.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:saemobile/utils/UserTools.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final _formKey = GlobalKey<FormBuilderState>();
  final UserTools loginState = UserTools();

  /// Connexion Supabse
  Future<void> _login() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final email = _formKey.currentState!.value['email'];
      final password = _formKey.currentState!.value['password'];

      final errorMessage = await loginState.login(email, password);
      if (errorMessage == null) {
        context.go("/home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $errorMessage")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Connexion", style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 16.0),

                FormBuilderTextField(
                  name: 'email',
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.7)),
                  ),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un email' : null,
                ),

                SizedBox(height: 16.0),

                FormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.7)),
                  ),
                  validator: (value) => (value != null && value.length < 4)
                      ? 'Le mot de passe doit contenir au moins 8 caractères'
                      : null,
                ),

                SizedBox(height: 16.0),

                ElevatedButton(
                  onPressed: _login,
                  child: Text("Se connecter"),
                ),

                SizedBox(height: 16.0),

                RetourButton(onPressed: () => context.go("/")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
