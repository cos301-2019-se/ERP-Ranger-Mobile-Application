
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {

  static final Auth _instance = new Auth._internal();

  factory Auth() {
    return _instance;
  }

  Auth._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  SharedPreferences _preferences = null;

  Future<void> _init() async {
    if (this._preferences == null) {
      this._preferences = await SharedPreferences.getInstance();
    }
  }

  Future<String> signIn(String email, String password) async {
    await this._init();
    FirebaseUser user = await this._firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    this._rememberUser(user.uid);
    return user.uid;
  }

  Future<void> signOut() async {
    await this._init();
    this._preferences.remove('user');
    return this._firebaseAuth.signOut();
  }

  Future<void> _rememberUser(String uid) async {
    if (uid != null) {
      this._preferences.setString('user', uid);
    }
  }

  Future<bool> checkUserLogin() async {
    await this._init();
    FirebaseUser user = await this._firebaseAuth.currentUser();
    if (user != null) {
      this._rememberUser(user.uid);
      return true;
    }
    return false;
  }

  Future<String> getUserUid() async {
    await this._init();
    return this._preferences.getString('user');
  }

}