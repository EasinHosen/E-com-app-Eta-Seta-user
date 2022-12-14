import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get user => _auth.currentUser;

  static Future<bool> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return credential.user != null;
  }

  static Future<bool> register(
      String name, String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    // final userModel = UserModel(uid: credential.user!.uid, email: email,
    //     creationTime: Timestamp.fromDate(credential.user!.metadata.creationTime!));

    credential.user!.updateDisplayName(name);
    return credential.user != null;
  }

  static Future<UserCredential> signInWithGoogle() async {
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

  static Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  static bool isEmailVerified() => _auth.currentUser!.emailVerified;

  static Future<void> sendVerificationEmail() =>
      _auth.currentUser!.sendEmailVerification();

  static Future<void> updateDisplayName(String name) =>
      _auth.currentUser!.updateDisplayName(name);

  static Future<void> updateDisplayImage(String image) =>
      _auth.currentUser!.updatePhotoURL(image);

  static Future<void> logout() => _auth.signOut();
}
