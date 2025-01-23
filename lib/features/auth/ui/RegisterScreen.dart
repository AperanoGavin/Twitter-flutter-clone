import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/Register/RegisterEvent.dart';
import '../blocs/Register/RegisterBloc.dart';
import '../blocs/Register/RegisterState.dart';

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
      appBar: AppBar(title: Text('Register')),
      body: BlocProvider(
        create: (context) => RegisterBloc(),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User registered successfully!')));
            }
            if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registration failed: ${state.errorMessage}')));
            }
          },
          builder: (context, state) {
            if (state is RegisterLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  TextField(
                    controller: avatarController,
                    decoration: InputDecoration(labelText: 'Avatar URL'),
                    onChanged: (value) {
                      setState(() {
                        avatarUrl = isValidUrl(value) ? value : null;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  avatarUrl != null
                      ? Image.network(avatarUrl!,
                          height: 100, width: 100, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image_not_supported, size: 100);
                          })
                      : Icon(Icons.person, size: 100),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<RegisterBloc>(context).add(RegisterSubmitted(
                        email: emailController.text,
                        password: passwordController.text,
                        username: usernameController.text,
                        avatar: isValidUrl(avatarController.text) ? Uri.tryParse(avatarController.text) : null,
                      ));
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
