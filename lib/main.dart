import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/blocs/login/LoginBloc.dart';
import 'features/auth/blocs/register/RegisterBloc.dart';
import 'features/auth/ui/LoginScreen.dart';
import 'features/auth/ui/RegisterScreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Automatically follow system setting
      home: BlocProvider(
        create: (context) => LoginBloc(),
        child: LoginScreen(),
      ), // Point d'entrée de l'app
    );
  }
}