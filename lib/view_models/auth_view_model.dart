import 'package:mood_tracker/services/auth_web_services.dart';

class AuthViewModel {
  final _authWebServices = AuthWebServices();

  Future<void> signInWithGoogle() async {
    await _authWebServices.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authWebServices.signOut();
  }
}
