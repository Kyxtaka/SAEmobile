
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/UI/themes/boutonRetour.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

class Login extends StatefulWidget {
  /// utilisation d'un statefulwidget pour les etats des fields
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormBuilderState>();

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

                // Champ Email
                FormBuilderTextField(
                  name: 'email',
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.0),

                // Champ Mot de passe
                FormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Le mot de passe doit contenir au moins 8 caractères';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.0),

                // Bouton de connexion
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      final formData = _formKey.currentState!.value;
                      print("Données valides : $formData");
                      context.go("/home"); // Redirige après connexion
                    } else {
                      print("Validation échouée");
                    }
                  },
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
