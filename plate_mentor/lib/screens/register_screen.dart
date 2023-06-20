import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form.dart';
import '../widgets/google_signin_button.dart';
import '../widgets/logo.dart';
import 'tabs_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const id = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _register() {
    final isValid = _formKey.currentState!.validate();
    _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then(
      (value) {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
        createUserInFirestore();
      },
    ).onError((error, stackTrace) {
      print(error);
      var errorMessage = 'There was an error';
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'invalid-email':
            errorMessage = 'This is not a valid email';
            break;
          case 'email-already-in-use':
            errorMessage = 'Account already exists';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Firebase email & password register not enabled';
            break;
          case 'weak-password':
            errorMessage = 'Password too weak';
            break;

          default:
        }
      }
      var snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void createUserInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'favorites': [],
      'dietPlan': [],
    });
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    final passwordRegex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    if (value.length < 8) {
      return 'Password too short, 8 characters minimum';
    }
    if (!passwordRegex.hasMatch(value)) {
      return 'At least one letter, one number & one sign "!@#\$&*~"';
    }
    if (value.toUpperCase() == value) {
      return 'Password must contain at least one lowercase letter';
    }

    if (value.toLowerCase() == value) {
      return 'Password must contain at least one uppercase letter';
    }

    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80),

                    //image logo
                    Logo(
                      size: 70,
                    ),

                    SizedBox(height: 60),

                    //email
                    CustomTextForm(
                      textInputType: TextInputType.emailAddress,
                      formKey: _formKey,
                      controller: _emailController,
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Email is required';
                        }

                        if (!EmailValidator.validate(email)) {
                          return 'Email format is incorrect';
                        }

                        return null;
                      },
                      hintText: 'Email',
                    ),
                    SizedBox(height: 10),

                    //password
                    CustomTextForm(
                      textInputType: TextInputType.visiblePassword,
                      formKey: _formKey,
                      obscureText: true,
                      controller: _passwordController,
                      hintText: 'Password',
                      validator: validatePassword,
                    ),

                    SizedBox(height: 10),

                    //confirm password
                    CustomTextForm(
                      textInputType: TextInputType.visiblePassword,
                      formKey: _formKey,
                      obscureText: true,
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password is required';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onSubmit: () {
                        _formKey.currentState!.validate();
                        _register();
                      },
                    ),

                    SizedBox(height: 10),

                    //login button
                    CustomButton(
                      horizontalEdge: 25,
                      text: 'Register',
                      onTap: _register,
                    ),
                    SizedBox(height: 10),

                    //google sign in
                    GoogleSignInButton(
                      onSignIn: (user) {
                        try {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${user.email}')));
                          Navigator.of(context).pushNamed(TabsScreen.id);
                        } catch (exception) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Error')));
                          Navigator.of(context).pushNamed(TabsScreen.id);
                        }
                      },
                    ),

                    //back to login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an Account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.id);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
