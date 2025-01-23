import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/login/LoginEvent.dart';
import '../blocs/login/LoginBloc.dart';
import '../blocs/login/LoginState.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful!')));
            }
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${state.errorMessage}')));
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<LoginBloc>(context).add(LoginSubmitted(
                        email: emailController.text,
                        password: passwordController.text,
                      ));
                    },
                    child: Text('Login'),
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
