import 'package:esgix/core/model/post/post.dart';
import 'package:esgix/core/network/endpoints/UserApi.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/ui/post/ManagePostScreen.dart';
import 'package:esgix/features/ui/post/details/PostDetailScreen.dart';
import 'package:esgix/features/ui/post/search/PostSearchScreen.dart';
import 'package:esgix/repositories/userRepository.dart';
import 'package:esgix/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/blocs/auth/login/LoginBloc.dart';
import 'features/ui/auth/LoginScreen.dart';
import 'features/ui/profil/ProfilScreen.dart';
import 'package:provider/provider.dart';
import 'features/ui/home/HomeScreen.dart';
import 'repositories/postRepository.dart';
import 'core/network/endpoints/posts/PostApi.dart';
import 'features/ui/post/like/ListLikeScreen.dart';
import 'features/ui/profil/UserProfilScreen.dart';
import 'package:esgix/features/blocs/profil/ProfilBloc.dart';


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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        'profil/userId': (context) {
          final userId = ModalRoute.of(context)!.settings.arguments as String;
          return BlocProvider(
            create: (context) => ProfilBloc(
              userRepository: context.read<UserRepository>(),
              authService: context.read<AuthService>(),
            ),
            child: UserProfilScreen(userId: userId),
          );
        },
        '/home': (context) {
          return BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            )..add(LoadPosts(page: 0 )),
            child: const HomeScreen(),
          );
        }, 
         '/comment': (context) {
          final String? parent = ModalRoute.of(context)?.settings.arguments as String?;
          return BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            )..add(LoadPosts(page: 0, parent:parent )),
            child: HomeScreen( parent: parent),
          );
        },  
        '/postsByUser': (context) {
          final String? userId = ModalRoute.of(context)?.settings.arguments as String?;
          return BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            )..add(LoadPosts(page: 0, userId:userId )),
            child: HomeScreen( userId: userId),
          );
        },
        '/userAllPostsLike': (context) {
          final String? userAllPostsLike = ModalRoute.of(context)?.settings.arguments as String?;
          return BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            )..add(LoadPosts(page: 0, userAllPostsLike:userAllPostsLike )),
            child: HomeScreen( userAllPostsLike: userAllPostsLike),
          );
        },   
        '/managePost': (context) {
          final post = ModalRoute.of(context)!.settings.arguments as Post?;
          return BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            ),
            child: ManagePostScreen(post: post ),
          );
        },
        '/CommentPost': (context) {
          final parent = ModalRoute.of(context)!.settings.arguments as String?;
          return BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            ),
            child: ManagePostScreen(parent: parent),
          );
        },
        '/post/id':(context){
          final postId = ModalRoute.of(context)!.settings.arguments as String;
          return BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            ),
            child: PostDetailScreen(postId: postId),
          );
        }
        ,
         '/likes': (context) {
          final postId = ModalRoute.of(context)!.settings.arguments as String;
          return BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            ),
            child: ListLikeScreen(postId: postId),
          );
        },
        '/search': (context) => BlocProvider(
          create: (context) => PostBloc(
            postRepository: context.read<PostRepository>(),
          ),
          child: const PostSearchScreen(),
        ),
        
       
      },
    );
  }
}