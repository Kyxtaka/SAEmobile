import 'package:flutter/material.dart';
import 'package:saemobile/services/local/tables/userTable.dart';
import 'package:saemobile/models/user.dart';
import '../utils/UserTools.dart';

class Profile extends StatefulWidget {
  final String userEmail;
  const Profile({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final UserTable _userTable = UserTable();

  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = await _userTable.getUserByEmail(widget.userEmail);
    if (user != null) {
      setState(() {
        _nomController.text = user.nom;
        _prenomController.text = user.prenom;
        _isConnected = user.connected;
      });
    }
  }
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    User updatedUser = User(
        widget.userEmail,
        _passwordController.text.isNotEmpty ? _passwordController.text : "",
        _nomController.text,
        _prenomController.text,
        "",
        [],
        _isConnected,
        ""
    );

    await _userTable.updateUser(updatedUser);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profil mis à jour avec succès !")),
    );
  }

  Future<void> _logout() async {
    await UserTools().logout();
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Votre profil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CircleAvatar(radius: 40, child: Icon(Icons.person, size: 50)),

              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: "Nom"),
                validator: (value) => value!.isEmpty ? "Entrez un nom" : null,
              ),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(labelText: "Prénom"),
                validator: (value) => value!.isEmpty ? "Entrez un prénom" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                initialValue: widget.userEmail,
                enabled: false, // Email non modifiable
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Nouveau mot de passe"),
                obscureText: true,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: "Confirmer mot de passe"),
                obscureText: true,
                validator: (value) {
                  if (_passwordController.text.isNotEmpty &&
                      value != _passwordController.text) {
                    return "Les mots de passe ne correspondent pas";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _updateProfile,
                child: Text("Modifier"),
              ),
              TextButton(
                onPressed: _logout,
                child: Text("Se déconnecter", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }



}