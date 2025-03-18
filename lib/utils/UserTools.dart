import 'package:supabase_flutter/supabase_flutter.dart';

///  gestion de la connexion, de l'inscription et déconnexion
class UserTools {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Vérifie si un utilisateur est connecté
  bool isConnected() {
    return supabase.auth.currentSession != null;
  }

  /// Connexion avec email et mot de passe
  Future<String?> login(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  /// Déconnexion de l'utilisateur
  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
