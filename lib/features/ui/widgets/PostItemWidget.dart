import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix/services/AuthService.dart';
import 'package:esgix/utils/validators.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/blocs/post/PostState.dart';
import 'package:esgix/core/model/post/post.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({
    super.key,
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

        return BlocBuilder<PostBloc, PostState>(
          buildWhen: (previous, current) {
            if (current is PostLoaded) {
              return current.posts.any((p) => p.id == post.id);
            } else if (current is PostSearchLoaded) {
              return current.posts.any((p) => p.id == post.id);
            }
            return false;
          },
          builder: (context, state) {
            Post currentPost = post;
            if (state is PostLoaded) {
              currentPost = state.posts.firstWhere(
                (p) => p.id == post.id,
                orElse: () => post,
              );
            } else if (state is PostSearchLoaded) {
              currentPost = state.posts.firstWhere(
                (p) => p.id == post.id,
                orElse: () => post,
              );
            }

            return Card(
              color: const Color.fromARGB(255, 11, 11, 11),
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête du post
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              'profil/userId', 
                              arguments: currentPost.author.id
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(currentPost.author.avatar ?? ""),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentPost.author.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              '${currentPost.createdAt.day}/${currentPost.createdAt.month}/${currentPost.createdAt.year}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (currentPost.author.id == currentUserId)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/managePost',
                                arguments: currentPost,
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  // Contenu du post
                  if (currentPost.imageUrl != null && 
                      currentPost.imageUrl!.isNotEmpty && 
                      !isOnlySpace(currentPost.imageUrl!))
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/post/id', arguments: currentPost.id);
                      },
                      child: Image.network(
                        currentPost.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        height: 400,
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/post/id', arguments: currentPost.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(currentPost.content),
                    ),
                  ),

                  // Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            (currentPost.likedByUser ?? false) 
                                ? Icons.favorite 
                                : Icons.favorite_border,
                            color: (currentPost.likedByUser ?? false) 
                                ? Colors.red 
                                : Colors.white,
                          ),
                          onPressed: () {
                            context.read<PostBloc>().add(LikePost(postId: currentPost.id));
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/likes', arguments: currentPost.id);
                          },
                          child: Text(
                            '${currentPost.likesCount}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () {
                            Navigator.pushNamed(context, '/comment', arguments: currentPost.id);
                          },
                        ),
                        Text('${currentPost.commentsCount}'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}