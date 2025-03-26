import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/viewsmodel/userviewmodel.dart';

class SettingsScreen extends StatefulWidget {

  final UserViewModel userViewModel;

  const SettingsScreen({super.key, required this.userViewModel});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();

}

class _SettingsScreenState extends State<SettingsScreen> {

  late UserViewModel userViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userViewModel = widget.userViewModel;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: new Footer().create(context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    backgroundColor: Colors.red
                ),
                onPressed: () async => {
                  await userViewModel.setDisconnection()
                },
                child: const Text(
                  'Déconnection',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}