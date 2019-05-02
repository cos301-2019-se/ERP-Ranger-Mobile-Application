import 'package:firebase_auth/firebase_auth.dart';

class Auth {

  static final Auth _instance = new Auth._internal();

  factory Auth() {
    return _instance;
  }

  Auth._internal();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await this.firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<void> signOut() async {
    return this.firebaseAuth.signOut();
  }

}