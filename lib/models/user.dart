class User {
  final String _mail;
  final String _password;
  final String _nom;
  final String _prenom;
  final String _role;
  final List _tester;
  final bool _connected;
  final String _localisation;

  const User(
      this._mail,
      this._password,
      this._nom,
      this._prenom,
      this._role,
      this._tester,
      this._connected,
      this._localisation);

  String get mail => _mail;

  String get password => _password;

  String get nom => _nom;

  String get prenom => _prenom;

  String get role => _role;

  List get tester => _tester;

  bool get connected => _connected;

  String get localisation => _localisation;

  void debugPrint() {
    String user = "mail: $_mail, password: $_password, nom: $_nom, prenom: $_prenom, role: $_role, tester: $_tester, connected: $_connected, localisation: $_localisation";
    print(user);
  }

  Map<String, Object?> toMapLocal() {
    return {
      'mail': _mail,
      'connected': _connected,
      'localisation': _localisation
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['mail'] as String,
      map['password'] as String,
      map['nom'] as String,
      map['prenom'] as String,
      map['role'] as String? ?? "",  // Si null, mettre une chaîne vide
      map['tester'] != null ? List.from(map['tester']) : [],  // Assurer une liste vide par défaut
      map['connected'] == 1,  // SQLite stocke `bool` en `int` (1 = true, 0 = false)
      map['localisation'] as String? ?? "", // Valeur par défaut si null
    );
  }

  /// 🔹 **Ajout de la méthode `toMap` pour sauvegarde en base**
  Map<String, dynamic> toMap() {
    return {
      'mail': _mail,
      'password': _password,
      'nom': _nom,
      'prenom': _prenom,
      'role': _role,
      'tester': _tester,
      'connected': _connected ? 1 : 0, // Convertir en `int` pour SQLite
      'localisation': _localisation,
    };
  }
}