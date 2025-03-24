import 'dart:convert';
import 'package:saemobile/utils/UserTools.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';


import 'global/header.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormBuilderState>();
  final UserTools loginState = UserTools();

  Future<void> _signin() async {
    try {
    if (_formKey.currentState!.saveAndValidate()) {
      var field = true;
      final email = _formKey.currentState!.value['Email'];
      final password = _formKey.currentState!.value['Mot de passe'];
      final prenom =  _formKey.currentState!.value['Prénom'];
      final nom =  _formKey.currentState!.value['Nom'];
      final confirm =  _formKey.currentState!.value['Confirmer mot de passe'];
      if (password != confirm){
        field = false;
      }
      var bytes = utf8.encode(password);
      var digest = r"\x" + sha256.convert(bytes).toString();

      var errorMessage = await loginState.signin(nom, prenom, email, digest, field);
      if (errorMessage == null) {
        context.go("/home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $errorMessage")),
        );
      }
    }
  } catch (error){
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text("Champs à compléter")));
  }
  }


  @override
  Widget build(BuildContext context) {
    Header header = new Header();
    return Scaffold(
      appBar: header.create(),
        body: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
          key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 30.0),

                    const Text(
                      "Inscription",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Créer un compte",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      decoration: InputDecoration(
                          hintText: "Nom",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.orange[200],
                          filled: true,
                          prefixIcon: const Icon(Icons.person)), name:'Nom',
                      validator: (value) => value!.isEmpty ? 'Veuillez entrer un nom' : null,
                    ),

                    const SizedBox(height: 20),
                    FormBuilderTextField(
                      decoration: InputDecoration(
                          hintText: "Prénom",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.orange[200],
                          filled: true,
                          prefixIcon: const Icon(Icons.person)), name: 'Prénom',
                      validator: (value) => value!.isEmpty ? 'Veuillez entrer un prenom' : null,
                        ),
                        const SizedBox(height: 20),

                    FormBuilderTextField(
                      decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.orange[200],
                          filled: true,
                          prefixIcon: const Icon(Icons.email)), name:'Email',
                        validator: (value) => value!.isEmpty ? 'Veuillez entrer un email' : null,
                    ),

                    const SizedBox(height: 20),

                    FormBuilderTextField(
                      decoration: InputDecoration(
                        hintText: "Mot de passe",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.orange[200],
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: true, name: 'Mot de passe',
                      validator: (value) => value!.isEmpty ? 'Veuillez entrer un mot de passe' : null,
                    ),

                    const SizedBox(height: 20),

                    FormBuilderTextField(
                      decoration: InputDecoration(
                        hintText: "Confirmer votre mot de passe",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.orange[200],
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: true, name:'Confirmer mot de passe',
                      validator: (value) => value!.isEmpty ? 'Veuillez confirmer votre mot de passe' : null,
                    ),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),

                    child: ElevatedButton(
                      onPressed: _signin,
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.orangeAccent,
                      ),
                      child: const Text(
                        "C'est parti !",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    )
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Déja un compte"),
                    TextButton(
                        onPressed: () => context.go("/login"),
                        child: const Text("Connexion", style: TextStyle(color: Colors.deepOrangeAccent),)
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}