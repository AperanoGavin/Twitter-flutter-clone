
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/blocs/post/PostState.dart';
import 'package:esgix/core/model/post/post.dart';


class PostItem extends StatelessWidget {
  final Post post;

  PostItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(post.imageUrl ?? ''),
        ),
        title: Text(post.content),
        subtitle: Text('Likes: ${post.likesCount} | Comments: ${post.commentsCount}'),
        trailing: IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {
            context.read<PostBloc>().add(LikePost(postId: post.id));
          },
        ),
      ),
    );
  }
}