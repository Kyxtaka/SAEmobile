

import 'package:flutter/material.dart';

class Header extends AppBar{
  AppBar create() {
    return AppBar(
        title: Text("IUTables'O"),
        actions:[ImageIcon(
          AssetImage("../../../assets/logo.png"),

        )],
    );
  }

}