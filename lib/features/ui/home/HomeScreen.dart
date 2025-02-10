import 'package:esgix/core/model/user/user.dart';
import 'package:esgix/features/blocs/post/PostState.dart';
import 'package:esgix/features/ui/widgets/PostItemWidget.dart';
import 'package:esgix/repositories/postRepository.dart';
import 'package:esgix/repositories/userRepository.dart';
import 'package:esgix/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/ui/widgets/NavbarWidget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:esgix/core/model/post/post.dart';


class HomeScreen extends StatefulWidget {
  final String? parent;
  final String? userId;
  final String? userAllPostsLike;
  const HomeScreen({super.key , this.parent , this.userId , this.userAllPostsLike});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, Post> _pagingController =  PagingController(firstPageKey: 0);
  static const _pageSize = 10; // Correspondant à l'offset de l'API
  late PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = PostBloc(
      postRepository: context.read<PostRepository>(),
    );
    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      _postBloc.add(LoadPosts(page: pageKey ~/ _pageSize , parent : widget.parent , userId: widget.userId  , userAllPostsLike: widget.userAllPostsLike)); // Division entière
      
      await for (final state in _postBloc.stream) {
        if (state is PostLoaded) {
          final isLastPage = state.hasReachedMax;
          final newItems = pageKey == 0 
              ? state.posts 
              : state.posts.skip(pageKey).take(_pageSize).toList(); // On prend les éléments de la page actuelle

          if (isLastPage) {
            _pagingController.appendLastPage(newItems);
          } else {
            final nextPageKey = pageKey + newItems.length;
            _pagingController.appendPage(newItems, nextPageKey);
          }
          break;
        } else if (state is PostError) {
          _pagingController.error = state.message;
          break;
        }
      }
    } catch (error) {
      _pagingController.error = error.toString();
    }
  }

  Future<void> _refresh() async {
    _pagingController.refresh();
  }


  @override
  void dispose() {
    _pagingController.dispose();
    _postBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UserRepository>();  
    
    return FutureBuilder<User?>(
      future: userRepository.getCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(); 
        }

      final _user = snapshot.data;


    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider.value(
        value: _postBloc,
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: Colors.black,
          backgroundColor: Colors.transparent,
          strokeWidth: 0.01,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                 leading: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'profil/userId', arguments: _user?.id); // Remplacez `userId` par l'ID de l'utilisateur actuel
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_user?.avatar ?? ""), // Remplacez `user.avatar` par l'URL de l'avatar de l'utilisateur
                      ),
                    ),
                  ),
                title: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/X_logo_2023_%28white%29.png/480px-X_logo_2023_%28white%29.png',
                  height: 40,
                ),
                backgroundColor: Colors.black,
                floating: false,
                snap: false,
                pinned: true,
                automaticallyImplyLeading: false,
              ),
              
              // Posts List with flutter_infinite_scroll_pagination
              PagedSliverList<int, Post>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Post>(
                  itemBuilder: (context, post, index) => PostItem(
                    key: ValueKey(post.id),
                    post: post,
                  ),
                  firstPageProgressIndicatorBuilder: (_) => const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  newPageProgressIndicatorBuilder: (_) => const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => const Center(
                    child: Text(
                      'No posts available',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  noMoreItemsIndicatorBuilder: (_) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Text(
                        'No more posts',
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Something went wrong',
                          style: TextStyle(color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: () => _pagingController.refresh(),
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.parent == null
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF1DA1F2),
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/managePost');
                if (result == true) {
                  _refresh();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: const NavbarWidget(),
    );
  }
    );
  }
}