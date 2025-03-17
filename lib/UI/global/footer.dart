import 'package:flutter/material.dart';

class Footer extends BottomNavigationBar {
  Footer({required super.items});

  BottomNavigationBar create() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
        BottomNavigationBarItem(
        icon: Icon(Icons.bookmark),
        label: 'Bookmark',
      ),
        BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      )]);
  }

}
