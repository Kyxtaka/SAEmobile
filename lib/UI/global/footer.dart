import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../api/viewsmodel/userviewmodel.dart';

class Footer {
  BottomNavigationBar create(BuildContext context) {
    int selectedIndex = _getSelectedIndex(context);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.orange[200],
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoris"),
        BottomNavigationBarItem(icon: Icon(Icons.messenger_outline), label: "Avis"),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        //code d'Ophelie
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  /// determine l'onglet en focntion  url
  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/favoris')) return 2;
    if (location.startsWith('/avis')) return 3;
    if (location.startsWith('/settings')) return 4;
    if (location.startsWith('/profile')) return 5;
    return 0;
  }

  /// change de page en fonction de l'index
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/accueil');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/favoris');
        break;
      case 3:
        context.go('/avis');
        break;
      case 4:
        context.go('/settings');
        break;
      //code d'ophelie
      case 5:
        final userViewModel = Provider.of<UserViewModel>(context, listen: false);
        if (userViewModel.isConnected()) {
          context.go('/profile/${UserViewModel.getCurrentUser()}');
        } else {
          context.go('/login');
        }
        break;
    }
  }
}
