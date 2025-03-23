import 'package:flutter/material.dart';

class Footer{
  BottomNavigationBar create() {
    return  BottomNavigationBar(items: [
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
      )],);}
    }