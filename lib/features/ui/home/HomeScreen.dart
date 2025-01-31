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
      body: BlocProvider(
        create: (context) => PostBloc(
          postRepository: context.read<PostRepository>(),
        )..add(LoadPosts(page: 0)),
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is PostLoaded) {

              return RefreshIndicator(
                onRefresh: () async {
                    context.read<PostBloc>().add(LoadPosts(page: 0));
                },
                color: Colors.black,
                backgroundColor: Colors.transparent,
                strokeWidth: 0.01,
                
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/X_logo_2023_%28white%29.png/480px-X_logo_2023_%28white%29.png',
                          height: 40, // Adjust the height as needed
                      ),
                      backgroundColor: Colors.black,
                      floating: true,
                      snap: true,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.posts[index];
                          return PostItem(post: post);
                        },
                        childCount: state.posts.length,
                      ),
                    ),
                  ],
                )
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
            context.read<PostBloc>().add(LoadPosts(page: 0));
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