import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_event.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_state.dart';
import 'package:watchmelater/presentation/pages/watch_screen.dart';
import 'package:watchmelater/presentation/pages/main_screen.dart';
import 'package:watchmelater/presentation/styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('watchmeLATER'), centerTitle: false),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            context.read<AuthBloc>().add(BackToLogin());
          }
        },
        child: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            if (state is UnAuthenticated) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset('assets/tomjerry.jpg'),
                      ),
                      const SizedBox(width: 200, child: Divider()),
                      const Text(
                        'Ughh, simple app to save those movies for later. That\'s it.\nJust login and save them.\n No bs.',
                        textAlign: TextAlign.center,
                        style: appBarTitleTextStyle,
                      ),
                      const SizedBox(width: 200, child: Divider()),
                      ElevatedButton(
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.black),
                            foregroundColor:
                                const WidgetStatePropertyAll(Colors.white)),
                        onPressed: () {
                          context.read<AuthBloc>().add(GoogleSignInRequested());
                        },
                        child: const Text('Login with Google'),
                      ),
                    ]),
              );
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          }),
        ),
      ),
    );
  }
}
