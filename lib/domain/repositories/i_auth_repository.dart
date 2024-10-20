import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepository {
  Stream<User?> get authStateChanges;

  Future<UserCredential> signInWithGoogle();

  Future<void> signOut();

  User? getCurrentUser();

  bool isAuthenticated();

  // Optional: Other auth methods you might need
  // Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  // Future<UserCredential> createUserWithEmailAndPassword(String email, String password);
  // Future<void> sendPasswordResetEmail(String email);
}
