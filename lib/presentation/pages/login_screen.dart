import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_event.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_state.dart';
import 'package:watchmelater/presentation/pages/watch_screen.dart';
import 'package:watchmelater/presentation/pages/main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is UnAuthenticated) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(GoogleSignInRequested());
                },
                child: const Text('Sign in with Google'),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        }),
      ),
    );
  }
}
