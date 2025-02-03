import 'dart:async';

import 'package:esgix/features/blocs/post/PostState.dart';
import 'package:esgix/features/ui/widgets/NavbarWidget.dart';
import 'package:esgix/features/ui/widgets/PostItemWidget.dart';
import 'package:esgix/repositories/postRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/core/model/post/post.dart';
import 'package:esgix/utils/validators.dart';


class PostSearchScreen extends StatefulWidget {
  const PostSearchScreen({Key? key}) : super(key: key);

  @override
  _PostSearchScreenState createState() => _PostSearchScreenState();
}

class _PostSearchScreenState extends State<PostSearchScreen> {

    Timer? _debounce;


  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<PostBloc>().add(SearchPosts(query: value));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: TextField(
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search...',
            filled: true,
            fillColor: Colors.black,
            contentPadding: EdgeInsets.all(1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
       
          if (state is PostSearchLoading) {

            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PostSearchLoaded) {
            final posts = state.posts;
            if (posts.isEmpty) {
              return Center(
                child: Text('No posts found'),
              );
            }
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostItem(post: post);
              },
            );
           
           
          }

          if (state is PostError) {
            return Center(
              child: Text('An error occurred: ${state.message}'),
            );
          }

          return Center(
            child: Text('No posts found'),
          );
                    

        },
      ),
       bottomNavigationBar: NavbarWidget(),

    );

  }


}
