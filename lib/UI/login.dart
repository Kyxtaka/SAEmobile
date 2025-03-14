
import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';

class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              )
            ],
          ),
        ));
  }
}