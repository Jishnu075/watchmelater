import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmelater/core/services/firebase_remoteconfig_service.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_event.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_state.dart';
import 'package:watchmelater/presentation/pages/main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseRemoteconfigService firebaseRemoteconfigService;
    return Scaffold(
      // appBar: AppBar(title: const Text('watchmeLATER'), centerTitle: false),
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
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            return Stack(alignment: Alignment.bottomCenter, children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      opacity: 0.1,
                      image: AssetImage('assets/login-poster.jpg'),
                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: AnimatedTextKit(
                              repeatForever: true,
                              pause: const Duration(milliseconds: 0),
                              animatedTexts: [
                                ColorizeAnimatedText(
                                    "Now save those movies you want to watch later",
                                    textStyle: const TextStyle(fontSize: 24),
                                    colors: [Colors.white, Colors.grey]),
                                ColorizeAnimatedText(
                                    "Never forget the name of that film someone recommended",
                                    textStyle: const TextStyle(fontSize: 24),
                                    colors: [Colors.white, Colors.grey]),
                                ColorizeAnimatedText(
                                    "Build your personal watchlist, simple and fast",
                                    textStyle: const TextStyle(fontSize: 24),
                                    colors: [Colors.white, Colors.grey]),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 150),
                          child: FilledButton(
                              // icon: Icon(Icons.g_mobiledata),
                              style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white10),
                              onPressed: () {},
                              child: const Text('Login with Google')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]);
          }
        }),
      ),
    );
  }
}

// return Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Image.asset('assets/tomjerry.jpg'),
//                       ),
//                       const SizedBox(width: 200, child: Divider()),
//                       Text(
//                         // 'Ughh, simple app to save those movies for later. That\'s it.\nJust login and save them.\n No bs.',
//                         FirebaseRemoteConfig.instance
//                             .getString('welcome_message'),
//                         textAlign: TextAlign.center,
//                         style: appBarTitleTextStyle,
//                       ),
//                       const SizedBox(width: 200, child: Divider()),
//                       ElevatedButton(
//                         style: ButtonStyle(
//                             shape: WidgetStatePropertyAll(
//                                 RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0))),
//                             backgroundColor:
//                                 const WidgetStatePropertyAll(Colors.black),
//                             foregroundColor:
//                                 const WidgetStatePropertyAll(Colors.white)),
//                         onPressed: () {
//                           context.read<AuthBloc>().add(GoogleSignInRequested());
//                         },
//                         child: const Text('Login with Google'),
//                       ),
//                     ]),
//               );
