

import 'package:flutter/material.dart';

class Header extends AppBar{
  static AppBar create() {
    return AppBar(
        title: Text("IUTables'O", style: TextStyle( color: Colors.black)),
        actions:[Image(image: AssetImage('assets/logo.png'),
        )],
    );
  }

}