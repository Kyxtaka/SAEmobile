
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user.dart';


class UserViewModel extends ChangeNotifier {
  late bool connectionStatus = false ;
  late SupabaseClient database;
  late String identifier;
  final BuildContext context;
  bool isAdmin = false;

  UserViewModel({required this.database, required this.context}) {}

  bool isConnected() {
    print("connection state : " + this.connectionStatus.toString());
    return connectionStatus;
  }


  Future<void>  setConnection(String identifier, String hashedPassword) async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    await prefs.setString('identifier', identifier);
    print("identifier writter ");
    await prefs.setString('hashedPassword',hashedPassword);
    print("hash written");


    connectionStatus = true;
    notifyListeners();
  }

  Future<void> autoLoginInit() async {
    //final SupabaseClient database = this.initSupabase() as SupabaseClient;
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    final identifier = await prefs.getString('identifier');
    print("get ident");
    final hashedPassword = await prefs.getString('hashedPassword');
    print("get hash written");

    // final identifier = await storage.read(key: 'identifier', aOptions: androidOptions, webOptions: webOptions);
    // final hashedPassword = await storage.read(key: 'hashedPassword', aOptions: androidOptions, webOptions: webOptions);
    print("autoLogin");
    print(identifier);
    print(hashedPassword);
    if (identifier != null && hashedPassword != null) {
      try {
        //this.database = await this.initSupabase();
        final result = await this.database
            .from("Visiteur")
            .select('mail, password')
            .eq('mail', identifier);
        if (result.isNotEmpty) {
          print(result[0]);
          print(hashedPassword);
          if(result[0]['mail']==identifier && result[0]['password']==hashedPassword){
            connectionStatus = true;
            print("connected from stored credential set connection status true");
            context.go('/accueil');
          }
          else {
            throw new Exception("Email ou mot de passe incorrect");
          }
        }
      }catch (e) {
        print(e);
      }
      finally {
        notifyListeners();
      }
    }
    notifyListeners();
  }



  Future<void> setDisconnection() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    await prefs.remove('identifier');
    print("identifier removed ");
    await prefs.remove('hashedPassword');
    print("hash removed");
    connectionStatus = false;
    notifyListeners();
  }

}