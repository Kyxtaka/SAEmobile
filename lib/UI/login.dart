
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/boutonRetour.dart';

class Login extends StatelessWidget{
  static Header header = new Header();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header.create(),
        body: Center(
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              Padding(
                padding: EdgeInsets.all(16.0),
                child:Text("Connexion"),),
              TextField( decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                hintText: 'email',
              ),),
              PasswordField(errorMessage: '''
                - A uppercase letter
                - A lowercase letter
                - A digit
                - A special character
                - A minimum length of 8 characters
                 ''',
                border: PasswordBorder(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0, color: Colors.grey),
                    borderRadius: BorderRadius.circular(25.7),
                  )
                ),
                hintText: 'mot de passe',
              ),
              RetourButton(onPressed: () => context.go("/")),
            ],
          ),
        ));
  }
}