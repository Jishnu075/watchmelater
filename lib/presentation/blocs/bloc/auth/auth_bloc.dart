import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:watchmelater/data/repositories/auth_repository.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_event.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) {
      // Check if user is already signed in
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthInitial());
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(
          AuthLoading()); // Emit loading state before starting the sign-in process
      try {
        final userCredential = await AuthRepository().signInWithGoogle();
        if (userCredential.user != null) {
          emit(Authenticated(userCredential.user!));
        } else {
          emit(AuthError(
              "Failed to retrieve user information after Google Sign-In"));
        }
      } catch (e) {
        emit(AuthError(
            "An error occurred during Google Sign-In: ${e.toString()}"));
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _firebaseAuth.signOut();
        await _googleSignIn.signOut();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthError("error occured during signout : $e"));
      }
    });
    on<BackToLogin>((event, emit) => emit(AuthInitial()));
  }
}
