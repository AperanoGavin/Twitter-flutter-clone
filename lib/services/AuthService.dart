import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    print('User ID from prefs: $userId'); // Debug print

    return userId;
  }

  Future<void> disconnect() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
          backgroundColor: Colors.black,
          iconPadding: const EdgeInsets.all(20),

          title: const Text('Déconnexion'),
          content: const Text('Voulez-vous vraiment vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Ferme la popup
                disconnect(); // Déconnecte l'utilisateur
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              
              },
              child: const Text('Déconnecter', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
    ),
  );
}

}