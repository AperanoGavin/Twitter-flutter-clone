import 'package:esgix/core/model/post/post.dart';
import 'package:esgix/core/network/endpoints/UserApi.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/ui/post/ManagePostScreen.dart';
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
import 'features/ui/home/HomeScreen.dart';
import 'repositories/postRepository.dart';
import 'core/network/endpoints/posts/PostApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/ui/post/like/ListLikeScreen.dart';


/*  */
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        Provider<UserApi>(
          create: (_) => UserApi(),
        ),
        Provider<PostApi>(
          create: (_) => PostApi(),
        ),
        Provider<UserRepository>(
          create: (_) => UserRepository(
            userApi: _.read<UserApi>(),
          )
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<PostRepository>(
          create: (_) => PostRepository(
             postApi: _.read<PostApi>(),
          )
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
      title: 'ESGIX',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      routes: {
         '/login': (context) => BlocProvider(
          create: (context) => LoginBloc(
            userRepository: context.read<UserRepository>(),
            authService: context.read<AuthService>(),
          ),
          child: LoginScreen(),
        ), 
        '/profil': (context) => BlocProvider(
          create: (context) => ProfilBloc(
            userRepository: context.read<UserRepository>(),
            authService: context.read<AuthService>(),
          ),
          child: ProfilScreen(),
        ),
        '/home': (context) => BlocProvider(
          create: (context) => PostBloc(
            postRepository: context.read<PostRepository>(),
          )..add(LoadPosts(page: 0)),
          child: HomeScreen(),
        ), 
        '/managePost': (context) {
          final post = ModalRoute.of(context)!.settings.arguments as Post?;
          return BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            ),
            child: ManagePostScreen(post: post),
          );
        },
         '/likes': (context) {
          final postId = ModalRoute.of(context)!.settings.arguments as String;
          return BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            ),
            child: ListLikeScreen(postId: postId),
          );
        },
        
       
      },
    );
  }
}