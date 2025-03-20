import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///  gestion de la connexion, de l'inscription et déconnexion
class UserTools {
  late SupabaseClient supabase = Supabase.instance.client;

  /// Vérifie si un utilisateur est connecté
  bool isConnected() {
    return supabase.auth.currentSession != null;
  }

  /// Connexion avec email et mot de passe
  Future<String?> login(String email, String password) async {
    try {
      final supabase = _initDb();
      final result = await this.supabase.from("Visiteur").select('mail, password').eq('mail', email);
      if (result.isNotEmpty) {
        print(result[0]);
        print(password);
        if(result[0]['mail']==email && result[0]['password']==password){
          print("connected");
          return null;
        }
        else {
          throw new Exception("Email ou mot de passe incorrect");
        }
      }
      else {
        throw new Exception("Erreur avec la base de données");
      }
    } catch (error) {
      print(error);
      return error.toString();
    }
  }
  Future<SupabaseClient> _initDb() async {
    try {
      await dotenv.load(fileName: ".env");
      await Supabase.initialize(
          url: dotenv.env['SUPABASE_DB_API_URL']??'',
          anonKey: dotenv.env['SUPABASE_ANON_KEY']??''
      );
      this.supabase = Supabase.instance.client;
      return Supabase.instance.client;
    } catch (e) {
      debugPrint("supabase and are already initialized");
      return Supabase.instance.client;
    }

  }

  /// Déconnexion de l'utilisateur
  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}


