
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/api/viewsmodel/critiquesviewmodel.dart';
import 'package:saemobile/api/viewsmodel/favorisviewmodel.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserViewModel extends ChangeNotifier {
  late bool connectionStatus = false ;
  late SupabaseClient database;
  static late String identifier;
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
    identifier = (await prefs.getString('identifier'))!; debugPrint("get identifier");
    notifyListeners();
  }

  Future<void> setTypePreferee(String type) async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    await prefs.setString('typePreferee', type);
  }


  Future<String> getTypePreferee() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    var type = prefs.getString("typePreferee");
    if (type != null){
      return type;
    }
    return "";
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

  Future<void> setLocalisation(Position position) async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    var pos = position.latitude.toString()+" ";
    pos += position.longitude.toString();
    await prefs.setString("position", pos);
  }
  static Future<LatLng> getLocalisation() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    var pos = await prefs.getString("position")??"47.916672 1.9";
    var localisation = pos.split(' ');
    debugPrint(localisation[0]);
    return LatLng(double.parse(localisation[0]), double.parse(localisation[1]));
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