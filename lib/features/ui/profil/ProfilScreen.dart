// screens/profil/profil_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/blocs/profil/ProfilBloc.dart';
import '../widgets/NavbarWidget.dart';
import '../../../features/blocs/navbar/NavbarBloc.dart';
import '../../../features/blocs/profil/ProfilEvent.dart';
import '../../../features/blocs/profil/ProfilState.dart';
import '../../../repositories/userRepository.dart';
import '../../../services/AuthService.dart';


class ProfilScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black,
      ),
      body: BlocProvider(
        create: (context) => ProfilBloc(
          userRepository: context.read<UserRepository>(),
          authService: context.read<AuthService>(),
        )..add(LoadProfil()),
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
              usernameController.text = state.user.username;
              descriptionController.text = state.user.description ?? '';
              avatarController.text = state.user.avatar ?? '';

              return SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildAvatarField(),
                      SizedBox(height: 20),
                      _buildUsernameField(),
                      SizedBox(height: 20),
                      _buildDescriptionField(),
                      SizedBox(height: 30),
                      _buildUpdateButton(context),
                      /* BlocProvider(
                        create: (context) => NavBloc(),
                        child: NavbarWidget(context),
                      ), */
                    ],
                  ),
                ),
              );
            }

            return Center(child: Text('Something went wrong!'));
          },
        ),
      ),
    );
  }

  Widget _buildAvatarField() {
    return TextFormField(
      controller: avatarController,
      decoration: InputDecoration(
        labelText: 'Avatar URL',
        prefixIcon: Icon(Icons.image, color: Colors.white),
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
        prefixIcon: Icon(Icons.person, color: Colors.white),
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
        prefixIcon: Icon(Icons.description, color: Colors.white),
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
          context.read<ProfilBloc>().add(
            UpdateProfil(
              username: usernameController.text,
              description: descriptionController.text,
              avatar: avatarController.text,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text('Update Profile'),
    );
  }
}