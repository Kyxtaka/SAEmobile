class User {
  String mail;
  String password;
  String nom;
  String prenom;
  String role;
  List<String> tester;
  bool connected;
  String localisation;

  User({
    required this.mail,
    required this.password,
    required this.nom,
    required this.prenom,
    required this.role,
    required this.tester,
    required this.connected,
    required this.localisation,
  });

  // Convertir l'objet en Map pour SQLite
  Map<String, dynamic> toMapLocal() {
    return {
      'mail': mail,
      'password': password,
      'nom': nom,
      'prenom': prenom,
      'role': role,
      'tester': tester.join(','),
      'connected': connected ? 1 : 0,
      'localisation': localisation,
    };
  }

  // Convertir un Map en User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      mail: map['mail'] as String,
      password: map['password'] as String,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      role: map['role'] as String,
      tester: (map['tester'] as String).split(','),
      connected: (map['connected'] as int) == 1,
      localisation: map['localisation'] as String,
    );
  }
}