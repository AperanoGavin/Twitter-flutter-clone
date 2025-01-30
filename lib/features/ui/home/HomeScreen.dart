import 'package:esgix/features/blocs/post/PostState.dart';
import 'package:esgix/features/ui/widgets/PostItemWidget.dart';
import 'package:esgix/repositories/postRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/ui/widgets/NavbarWidget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.black,
      ),
      body: BlocProvider(
        create: (context) => PostBloc(
          postRepository: context.read<PostRepository>(),
        )..add(LoadPosts(page: 1)),
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is PostLoaded) {
              return RefreshIndicator(
                strokeWidth: 100, //
                color: Colors.black,
                backgroundColor: Colors.white,
                onRefresh: () async {
                  context.read<PostBloc>().add(LoadPosts(page: 1));
                },
                child: ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return PostItem(post: post);
                  },
                ),
              );
            }

            if (state is PostError) {
              return Center(child: Text(state.message));
            }

            return Center(child: Text('No posts available'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1DA1F2), // Twitter blue color
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/managePost');
          if (result == true) {
            // Trigger an API call to refresh the data
            context.read<PostBloc>().add(LoadPosts(page: 1));
          }
        },
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Ensure circular shape
        ),
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}