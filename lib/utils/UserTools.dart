import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///  gestion de la connexion, de l'inscription et déconnexion
class UserTools {
  late SupabaseClient supabase = Supabase.instance.client;

  /// Vérifie si un utilisateur est connecté
  bool isConnected() {
    return supabase.auth.currentSession != null;
  }

  SupabaseClient get client {
    return supabase;
  }

  UserTools({required this.supabase}) {}
  /// Connexion avec email et mot de passe
  Future<String?> login(String email, String password) async {
    try {
      final result = await this.supabase
          .from("Visiteur")
          .select('mail, password')
          .eq('mail', email)
          .maybeSingle();

      if (result != null && result['mail']==email && result['password']==password) {
        print(result);
        print(password);
        print("connected");
        return null;
        /*
        if(result['mail']==email && result['password']==password){
          print("connected");
          return null;
        }
        else {
          throw new Exception("Email ou mot de passe incorrect");
        }
         */
      }
      else {
        throw new Exception("Email ou mot de passe incorrect");
      }
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  Future<String?> signin(String nom, String prenom, String email, String password, field) async {
    try {
      if (!field){
        throw new Exception("Le mot de passe est différent");
      }
      //final supabase = _initDb();
      final result = await this.supabase.from("Visiteur").select('mail, password').eq('mail', email);
      if (result.isNotEmpty) {
        if(result[0]['mail']==email){
          throw new Exception("Vous avez déjà un compte");
        }
      }
      else {
        final result = await this.supabase.from("Visiteur").insert({'mail':email, 'password': password, 'prenom': prenom, 'nom_user': nom}).select();
        if (result.isNotEmpty){
          print("connected");
          return null;
        }
        throw new Exception("Le compte n'a pas pu être crée");
      }
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  /// Déconnexion de l'utilisateur
  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}

