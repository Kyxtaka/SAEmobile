
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/UI/themes/boutonRetour.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:saemobile/models/user.dart';

import 'package:saemobile/utils/UserTools.dart';

import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class Login extends StatefulWidget {
  final SupabaseClient database;
  final UserViewModel userViewModel;
  const Login({super.key, required this.userViewModel, required this.database});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final UserTools loginState;

  @override
  void initState() {
    this.loginState  = UserTools(supabase: this.widget.database);
  }

  /// Connexion Supabse
  Future<void> _login() async {
    try {
      if (_formKey.currentState!.saveAndValidate()) {
        final email = _formKey.currentState!.value['email'];
        final password = _formKey.currentState!.value['password'];
        var bytes = utf8.encode(password);
        var digest = r"\x" + sha256.convert(bytes).toString();

        final errorMessage = await loginState.login(email, digest);
        if (errorMessage == null) {
          print("before call email is " + email + " and hash is " + digest);

          await widget.userViewModel.setConnection(email, digest);
          print("error msg: $errorMessage");
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_email', email);
          context.go("/accueil");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur : $errorMessage")),
          );
        }
      }} catch (error){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Champs à compléter")));
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
