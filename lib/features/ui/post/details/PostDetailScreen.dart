import 'package:esgix/features/ui/widgets/NavbarWidget.dart';
import 'package:esgix/features/ui/widgets/PostItemWidget.dart';
import 'package:esgix/repositories/postRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/blocs/post/PostState.dart';



class PostDetailScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final String postId;

  PostDetailScreen({super.key, required this.postId});

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
              return const Center(child: CircularProgressIndicator());
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
            return const Center(child: Text('Something went wrong!'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1DA1F2),
        onPressed: () async {
          print("postId: $postId");
          final result = await Navigator.pushNamed(context, '/CommentPost' , arguments: postId);
         /*  if (result == true) {
            _refresh();
          } */
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}