
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserViewModel extends ChangeNotifier {
  late bool connectionStatus = false ;
  late SupabaseClient database;
  late String identifier;
  final BuildContext context;
  bool isLoading = true;

  UserViewModel({required this.database, required this.context}) {
    autoLoginInit();

  }

  bool isConnected() {
    print("connection state : " + this.connectionStatus.toString());
    return connectionStatus;
  }


  Future<void>  setConnection(String identifier, String hashedPassword) async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    await prefs.setString('identifier', identifier); debugPrint("identifier written in local storage");
    await prefs.setString('hashedPassword',hashedPassword); debugPrint("hash written in local storage");
    connectionStatus = true;
    notifyListeners();
  }

  Future<void> autoLoginInit() async {
    debugPrint("autoLogin");
    isLoading = true;
    notifyListeners();

    final SharedPreferences prefs =  await SharedPreferences.getInstance();

    final identifier = prefs.getString('identifier'); debugPrint("get identifier");
    final hashedPassword = prefs.getString('hashedPassword'); debugPrint('get hash written');

    // final identifier = await storage.read(key: 'identifier', aOptions: androidOptions, webOptions: webOptions);
    // final hashedPassword = await storage.read(key: 'hashedPassword', aOptions: androidOptions, webOptions: webOptions);

    if (identifier != null && hashedPassword != null) {
      try {
        final result = await this.database
            .from("Visiteur")
            .select('mail, password')
            .eq('mail', identifier)
            .maybeSingle();

        if (result != null && result['mail']==identifier && result ['password']==hashedPassword) {
          connectionStatus = true;
          debugPrint("connected from stored credential set connection status true");
          context.go('/accueil');
        }
        else {
          throw new Exception("Email ou mot de passe incorrect");
        }
      }catch (e) {
        debugPrint(e.toString());
      }
    }
    isLoading = false; //
    notifyListeners();
  }

  Future<void> setDisconnection() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    await prefs.remove('identifier'); debugPrint("identifier removed ");
    await prefs.remove('hashedPassword'); debugPrint("hash removed");
    connectionStatus = false;
    notifyListeners();
  }

  static Future<String> getCurrentUser() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    var mail = prefs.getString("identifier");
    if (mail==null){
      return "";
    }
    return mail;
  }



}