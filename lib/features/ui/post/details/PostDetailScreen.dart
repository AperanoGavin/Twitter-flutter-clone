import 'package:esgix/features/ui/widgets/NavbarWidget.dart';
import 'package:esgix/features/ui/widgets/PostItemWidget.dart';
import 'package:esgix/repositories/postRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/blocs/post/PostState.dart';

import 'package:esgix/core/model/post/post.dart';
import 'package:esgix/utils/validators.dart';


class PostDetailScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final String postId;

  PostDetailScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
      ),
      body: BlocProvider(
        create: (context) => PostBloc(
          postRepository: context.read<PostRepository>(),
        )..add(LoadPostDetails( postId: postId)),
        child: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PostDetailsLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is PostDetailsLoaded) {
              final post = state.post;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    PostItem(post: post),
                  ],
                ),
              );
            
            }
            return Center(child: Text('Something went wrong!'));
          },
        ),
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}