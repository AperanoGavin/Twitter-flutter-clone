import 'package:esgix/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/core/model/post/post.dart';

class PostItem extends StatelessWidget {
  final Post post;

  PostItem({
    required this.post,
  });

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
                    CircleAvatar(
                      backgroundImage: NetworkImage(post.author.avatar ?? ""),
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
          if (post.imageUrl != null)
            Image.network(
              post.imageUrl!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(post.content),
          ),

              // Actions (like et commentaire)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        context.read<PostBloc>().add(LikePost(postId: post.id));
                      },
                    ),
                    Text('${post.likesCount}'),
                    SizedBox(width: 16.0),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        // Naviguer vers la page des commentaires
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