abstract class AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class AppStarted extends AuthEvent {}

class BackToLogin extends AuthEvent {}
