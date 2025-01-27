import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/Register/RegisterEvent.dart';
import '../../blocs/auth/Register/RegisterBloc.dart';
import '../../blocs/auth/Register/RegisterState.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();

  String? avatarUrl;

  bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasAbsolutePath && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => RegisterBloc(),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black,
                  content: Container(
                    padding: EdgeInsets.all(6),
                    height: context.size!.height * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User registered successfully!'),

                      ],
                    ),

                  )
                  
                ),
              );
            }
            if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black,
                  content: Container(
                    padding: EdgeInsets.all(10),
                    height: context.size!.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Registration failed:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(state.errorMessage, style: TextStyle(color: Colors.white)),
                      ],
                    ),

                  )
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is RegisterLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    _buildUsernameField(),
                    SizedBox(height: 16),
                    _buildEmailField(),
                    SizedBox(height: 16),
                    _buildPasswordField(),
                    SizedBox(height: 16),
                    _buildAvatarField(),
                    SizedBox(height: 10),
                    avatarUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12), 
                            child: Image.network(
                              avatarUrl!,
                              height: 100,
                              width: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image_not_supported, size: 100, color: Colors.white);
                              },
                            ),
                          )
                        : Icon(Icons.person, size: 100, color: Colors.white),
                    SizedBox(height: 20),
                    _buildRegisterButton(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: usernameController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.person_outline, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildAvatarField() {
    return TextFormField(
      controller: avatarController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Avatar URL',
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.link, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onChanged: (value) {
        setState(() {
          avatarUrl = isValidUrl(value) ? value : null;
        });
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        BlocProvider.of<RegisterBloc>(context).add(RegisterSubmitted(
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text,
          avatar: isValidUrl(avatarController.text) ? Uri.tryParse(avatarController.text) : null,
        ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Register',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}