import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:watchmelater/domain/repositories/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '572746477251-jvt8gim8ar611lbvd0mikij6tl117m7e.apps.googleusercontent.com',
  );
  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  bool isAuthenticated() {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
