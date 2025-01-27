import 'package:esgix/core/network/endpoints/UserApi.dart';
import 'package:esgix/repositories/userRepository.dart';
import 'package:esgix/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/blocs/auth/login/LoginBloc.dart';
import 'features/blocs/profil/ProfilBloc.dart';
import 'features/blocs/auth/register/RegisterBloc.dart';
import 'features/ui/auth/LoginScreen.dart';
import 'features/ui/profil/ProfilScreen.dart';
import 'features/ui/auth/RegisterScreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';


import 'package:shared_preferences/shared_preferences.dart';


/*  */
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        Provider<UserApi>(
          create: (_) => UserApi(),
        ),
        Provider<UserRepository>(
          create: (_) => UserRepository(
            userApi: _.read<UserApi>(),
          )
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (context) => LoginBloc(
          userRepository: context.read<UserRepository>(),
          authService: context.read<AuthService>(),
        ),
        child: LoginScreen(),
      ),
    );
  }
}