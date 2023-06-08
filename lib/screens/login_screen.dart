import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/tabs_screen.dart';
import 'package:get_storage/get_storage.dart';
import '../screens/register_screen.dart';
import 'package:flutter/material.dart';
import '../screens/forgot_password_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form.dart';
import '../widgets/google_signin_button.dart';
import '../widgets/logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logInEmailPassword() {
    final isValid = _formKey.currentState!.validate();
    _auth
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then(
      (value) {
        GetStorage().write('token', value.user!.uid);
        GetStorage().write('email', value.user!.email);

        //debug
        //print(GetStorage().read('token'));
        //print(GetStorage().read('email'));
        Navigator.pushReplacementNamed(context, TabsScreen.id);
      },
    ).onError(
      (error, stackTrace) {
        var snackBar = const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('There is an error'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
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

                    //password
                    CustomTextForm(
                      textInputType: TextInputType.visiblePassword,
                      formKey: _formKey,
                      obscureText: true,
                      controller: _passwordController,
                      hintText: 'Password',
                      validator: validatePassword,
                      onSubmit: () {
                        _formKey.currentState!.validate();
                        _logInEmailPassword();
                      },
                    ),

                    const SizedBox(height: 10),

                    //login button
                    CustomButton(
                      horizontalEdge: 25,
                      text: 'Login',
                      onTap: _logInEmailPassword,
                    ),
                    const SizedBox(height: 10),

                    //google sign in
                    GoogleSignInButton(
                      onSignIn: (user) {
                        try {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${user.email}')));
                          Navigator.of(context).pushNamed(TabsScreen.id);
                        } catch (exception) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error')));
                          Navigator.of(context).pushNamed(TabsScreen.id);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an Account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(RegisterScreen.id);
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ForgotPasswordScreen.id);
                        },
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold),
                        )),
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
