import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class Auth {
  RxBool isLoggedIn = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var currentUser;

  Auth() {
    initializeFirebase();
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      isLoggedIn.value = false;
      return;
    } catch (e) {
      print(e);
    }
  }

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    // TODO: Add auto login logic

    return firebaseApp;
  }

  // sign in with google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // get email
  Future<String?> getEmail() async {
    return _auth.currentUser?.email;
  }

  // get picture
  Future<String?> getPicture() async {
    return _auth.currentUser?.photoURL;
  }

//  sign in with email and password
  Future<dynamic> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      isLoggedIn.value = true;
      return userCredential.user;
    } catch (e) {
      print(e);
    }
  }

  // sign up with email and password
  Future<dynamic> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print(e);
    }
  }
}
