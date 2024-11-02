import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watchmelater/core/services/firebase_service.dart';
import 'package:watchmelater/data/repositories/movie_repository.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_event.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_state.dart';
import 'package:watchmelater/presentation/blocs/bloc/movie/movie_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/search/search_bloc.dart';
import 'package:watchmelater/presentation/pages/login_screen.dart';
import 'package:watchmelater/presentation/pages/watch_screen.dart';
import 'package:watchmelater/presentation/pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AppStarted()),
        ),
        BlocProvider<MovieBloc>(
            create: (context) => MovieBloc(
                  movieRepository:
                      MovieRepository(firestore: FirebaseService.firestore),
                )..add(LoadMoviesFromFirebase())),
        BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(
                  movieRepository:
                      MovieRepository(firestore: FirebaseService.firestore),
                )),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            home: state is Authenticated ? MainScreen() : const LoginScreen(),
          );
        },
      ),
    );
  }
}
