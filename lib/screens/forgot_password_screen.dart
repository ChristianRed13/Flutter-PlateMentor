import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form.dart';
import '../widgets/logo.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static const id = 'forgot_password_screen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    const SizedBox(height: 80),

                    //image logo
                    const Logo(
                      size: 70,
                    ),

                    const SizedBox(height: 60),

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
                    const SizedBox(height: 10),

                    //login button
                    CustomButton(
                      icon: const Icon(
                        Icons.mail_outline_outlined,
                        color: Colors.white,
                      ),
                      horizontalEdge: 25,
                      text: 'Send Email',
                      onTap: () async {
                        _formKey.currentState!.validate();
                        await _auth
                            .sendPasswordResetEmail(
                                email: _emailController.text.trim())
                            .then((value) {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.id);
                          var snackBar = const SnackBar(
                            content: Text(
                              'Success, chack your email',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }).onError((error, stackTrace) {
                          var snackBar = const SnackBar(
                            content: Text(
                              'Failed',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(LoginScreen.id);
                      },
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(
                            color: Color(0xFFC107),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
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
