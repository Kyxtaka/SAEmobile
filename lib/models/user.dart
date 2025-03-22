class User {
  final String _mail;
  final String _password;
  final String _nom;
  final String _prenom;
  final String _role;
  final List _tester;

  const User(
      this._mail,
      this._password,
      this._nom,
      this._prenom,
      this._role,
      this._tester);

  String get mail => _mail;

  String get password => _password;

  String get nom => _nom;

  String get prenom => _prenom;

  String get role => _role;

  List get tester => _tester;

  void debugPrint() {
    String user = "mail: $_mail, password: $_password, nom: $_nom, prenom: $_prenom, role: $_role, tester: $_tester";
    print(user);
  }

  Map<String, Object?> toMapLocal() {
    return {
      'mail': _mail,
      'password': _password,
      'nom': _nom,
      'prenom': _prenom,
      'role': _role,
      'tester': _tester,
    };
  }
}