import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ===================================================================================
import 'package:....../home_page.dart';
import 'package:....../login_page.dart';


// 
// ===================================================================================
class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // ==================================================================================

  handleAuthState() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  // ==================================================================================

  googleSignIn() async {
    // Trigger the authentication flow
    final newUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final googleauth = await newUser!.authentication;

    // Create a new credential
    final credentials = GoogleAuthProvider.credential(
      accessToken: googleauth.accessToken,
      idToken: googleauth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }

  // ==================================================================================

  signOut() async {
    // This line is mandatory for Android apps,..
    await _googleSignIn.signOut();
    // This line is enough if you build only for web,..
    await FirebaseAuth.instance.signOut();
  }
}
