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


class ProfilScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImageService _imageService = ImageService();

  ProfilScreen({super.key});

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        )..add(const LoadProfil()),
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
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfilLoaded) {
              usernameController.text = state.user.username;
              descriptionController.text = state.user.description ?? '';
              avatarController.text = state.user.avatar ?? '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildAvatarField(),
                      const SizedBox(height: 20),
                      _buildUsernameField(),
                      const SizedBox(height: 20),
                      _buildDescriptionField(),
                      const SizedBox(height: 30),
                      _buildUpdateButton(context),
                       /* BlocProvider(
                        create: (context) => NavBloc(),
                        child: NavbarWidget(),
                      ),  */
                    ],
                  ),
                ),
              );
            }

            return const Center(child: Text('Something went wrong!'));
          },
        ),
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }

  Widget _buildAvatarField() {
    return TextFormField(
      controller: avatarController,
      decoration: InputDecoration(
        labelText: 'Avatar URL',
        prefixIcon: const Icon(Icons.image, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
        prefixIcon: const Icon(Icons.person, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Username required' : null,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Description',
        prefixIcon: const Icon(Icons.description, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (isValidUrl(avatarController.text)) {
            context.read<ProfilBloc>().add(
              UpdateProfil(
                username: usernameController.text,
                description: descriptionController.text,
                avatar: avatarController.text,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('L\'URL de l\'avatar n\'est pas valide.'),
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Update Profile'),
    );
  }
}