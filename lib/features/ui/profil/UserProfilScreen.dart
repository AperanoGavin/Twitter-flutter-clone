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
                child: Column(
                  children: [
                    _buildAvatar(user.avatar),
                    SizedBox(height: 20),
                    _buildUsername(user.username),
                    SizedBox(height: 20),
                    _buildDescription(user.description),
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

  // Widget pour afficher l'avatar
  Widget _buildAvatar(String? avatarUrl) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
      child: avatarUrl == null ? Icon(Icons.person, size: 50) : null,
    );
  }

  // Widget pour afficher le nom d'utilisateur
  Widget _buildUsername(String username) {
    return Text(
      username,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Widget pour afficher la description
  Widget _buildDescription(String? description) {
    return Text(
      description ?? 'No description provided',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }
}