import 'package:esgix/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/core/model/post/post.dart';

class PostItem extends StatelessWidget {
  final Post post;


  const PostItem({
    Key? key,
    required this.post,
  }) : super(key: key);//super(key: key) permet de passer la clé key au constructeur de la classe parente (StatelessWidget) qui en a besoin pour identifier le widget dans le widget tree.

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    return FutureBuilder<String?>(
      future: authService.getUserId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(); 
        }

      final currentUserId = snapshot.data;

        return Card(
          color : const Color.fromARGB(255, 11, 11, 11),
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête du post (auteur et date)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'profil/userId', arguments: post.author.id);
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(post.author.avatar ?? ""),
                        ),
                      ),
                    
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    if (post.author.id == currentUserId) // Replace with actual user ID check
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                           Navigator.pushNamed(
                            context,
                            '/managePost',
                            arguments: post, // Passez le post comme argument
                          );
                        },
                      ),
                  ],
                ),
              ),

              // Contenu du post (texte et image)
              if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/post/id', arguments: post.id);
                },
                child: Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  height: 400,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/post/id', arguments: post.id);
                },
                child: 
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(post.content),
                  ),
              ),

              // Actions (like et commentaire)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        (post.likedByUser ?? false) ? Icons.favorite : Icons.favorite_border,
                        color: (post.likedByUser ?? false) ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        context.read<PostBloc>().add(LikePost(postId: post.id));
                      },
                    ),
                     GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/likes', arguments: post.id);
                      },
                      child: Text(
                        '${post.likesCount}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                      //Navigator.pushNamed(context, '/post/id', arguments: post.id);

                        Navigator.pushNamed(context, '/comment', arguments: post.id);
                      },
                    ),
                    Text('${post.commentsCount}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}