
import 'package:flutter/material.dart';
import 'UI/home.dart';
import 'UI/login.dart';
import 'UI/themes/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.defaultTheme();
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: "IUTables'O",
      home: Home(),
      theme: theme);
  }
  }