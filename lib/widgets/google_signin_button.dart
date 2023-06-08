import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInButton extends StatelessWidget {
  final Function(User) onSignIn;

  GoogleSignInButton({required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SignInButton(
        Buttons.Google,
        onPressed: () async {
          final GoogleSignIn googleSignIn = GoogleSignIn();
          final GoogleSignInAccount? account = await googleSignIn.signIn();
          if (account != null) {
            final GoogleSignInAuthentication googleAuth =
                await account.authentication;
            final AuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            final UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);
            onSignIn(userCredential.user!);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
