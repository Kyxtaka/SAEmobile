import 'dart:ffi';

class User {
  final String _mail;
  final String _password;
  final String _nom;
  final String _prenom;
  final String _role;
  final List _tester;
  final Bool _connected;
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

  Bool get connected => _connected;

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
}