import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/blocs/post/PostState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix/repositories/postRepository.dart';




class ListLikeScreen extends StatelessWidget {
  final String postId;

  ListLikeScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des likes'),
      ),
      body: BlocProvider(
        create: (context) => PostBloc(
          postRepository: context.read<PostRepository>(),
        )..add(LoadPostLikers(postId: postId)),
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is PostLikersLoaded) {
              return ListView.builder(
                itemCount: state.likers.length,
                itemBuilder: (context, index) {
                  final liker = state.likers[index];
                  return ListTile(
                    title: Text(liker.username),
                  );
                },
              );
            }

            if (state is PostError) {
              return Center(
                child: Text('Erreur lors du chargement des likes'),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}

