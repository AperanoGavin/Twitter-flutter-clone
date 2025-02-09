import 'package:flutter/material.dart';
import'package:esgix/services/AuthService.dart';


class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  int _getCurrentIndex(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    switch (currentRoute) {
      case '/home':
        return 0;
      case '/search':
        return 1;
      case '/profil':
        return 2;
      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
      final currentIndex = _getCurrentIndex(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onLongPress: () {
              final authService = AuthService();
              authService.showLogoutConfirmation(context);
            },
            child: const Icon(Icons.person), // Icône profil
          ),
          label: 'Profil',
         
        ),
      ],
      onTap: (index) {

         if (index == currentIndex) return;

        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/search');
            break;
          case 2:
             Navigator.pushReplacementNamed(context, '/profil');

            break;
        }
      },
    );
  }
}