// screens/profil/profil_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/blocs/profil/ProfilBloc.dart';
import '../widgets/NavbarWidget.dart';
import '../../../features/blocs/profil/ProfilEvent.dart';
import '../../../features/blocs/profil/ProfilState.dart';
import '../../../repositories/userRepository.dart';
import '../../../services/AuthService.dart';
import '../../../services/ImageService.dart';
import 'package:esgix/utils/validators.dart';


class UserProfilScreen extends StatelessWidget {
  final String userId; 
  final ImageService _imageService = ImageService();

  UserProfilScreen({required this.userId}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        flexibleSpace: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                _imageService.getRandomImageUrl(),
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => ProfilBloc(
          userRepository: context.read<UserRepository>(),
          authService: context.read<AuthService>(),
        )..add(LoadProfil(userId: userId)), // Charger le profil avec l'ID de l'utilisateur
        child: BlocConsumer<ProfilBloc, ProfilState>(
          listener: (context, state) {
            if (state is ProfilError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfilLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is ProfilLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        _buildAvatar(user.avatar),
                        SizedBox(height: 8),
                        _buildUsername(user.username),
                        SizedBox(height: 8),
                      ],
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildDescription(user.description),
                          SizedBox(height: 100),
                          Row(
                            children: [
                              _buildNavigationButtons(context),
                              //pousser ver la droite
                              
                            ],
                          ),                      
                        ],
                      ),
                    ),
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

  Widget _buildAvatar(String? avatarUrl) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
      child: avatarUrl == null ? Icon(Icons.person, size: 50) : null,
    );
  }

  Widget _buildUsername(String username) {
    return Text(
      username,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription(String? description) {
    if (description == null || description.isEmpty) {
      return Container();
    }
    return Container(
      height: 100, // Hauteur fixe pour le conteneur
      padding: EdgeInsets.all(17.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 23, 19, 19),
        borderRadius: BorderRadius.circular(28.0),
        //border: Border.all(color: Colors.white),
      ),
      child: SingleChildScrollView(
        child: Text(
          description ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Centrer les boutons verticalement
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/likedPosts', arguments: userId);
          },
          child: Text('Liked Posts'),
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        ),
        SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/userPosts', arguments: userId);
          },
          child: Text('All Posts'),
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 69),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        ),
      ],
    );
  }

}