import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///  gestion de la connexion, de l'inscription et déconnexion
class UserTools {
  late SupabaseClient supabase = Supabase.instance.client;

  UserTools({required this.supabase});

  SupabaseClient get client {
    return supabase;
  }

  /// Connexion avec email et mot de passe
  Future<String?> login(String email, String password) async {
    try {
      final result = await supabase
          .from("Visiteur")
          .select('mail, password')
          .eq('mail', email)
          .maybeSingle();

      if (result != null && result['mail']==email && result['password']==password) {
        print("connected");
        return null;
      }
      else {
        throw Exception("Email ou mot de passe incorrect");
      }
    } catch (error) {
      print("login error $error");
      return error.toString();
    }
  }

  Future<String?> signin(String nom, String prenom, String email, String password, field) async {
    try {
      if (!field){
        throw Exception("Le mot de passe est différent");
      }
      final result = await supabase
          .from("Visiteur")
          .select('mail, password')
          .eq('mail', email)
          .maybeSingle();

      if (result != null && result['mail'] == email) {
          throw Exception("Vous avez déjà un compte");
      }
      else {
        final result = await supabase
            .from("Visiteur")
            .insert({'mail':email, 'password': password, 'prenom': prenom, 'nom_user': nom})
            .select()
            .maybeSingle();
        if (result != null){ print("connected") ; return null;}
        throw Exception("Le compte n'a pas pu être crée");
      }
    } catch (error) {
      print(error);
      return error.toString();
    }
  }
}

