import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizapp/businesslogic/cubit/googlesignin_cubit.dart';
import 'package:quizapp/businesslogic/cubit/login_cubit.dart';
import 'package:quizapp/common/colors.dart';
import 'package:quizapp/common/flushbar.dart';
import 'package:quizapp/common/global.dart';
import 'package:quizapp/common/network.dart';
import 'package:quizapp/ui/signup_page.dart';
import 'package:quizapp/ui/start_quiz.dart';

import '../widgets/loading_widget.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth? firebaseAuth;

  const LoginPage({super.key, required this.firebaseAuth});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  var isVisible = false;

  login() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      var map = {
        "email": _email,
        "password": _password,
      };
      context.read<LoginCubit>().getUserSignIn(map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoogleSignInCubit, NetworkState<User>>(
      listener: (context, state) {
        if (state is Error<User>) {
          context.flushBarErrorMessage(message: state.message);
        } else if (state is Success<User>) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartQuiz(user: state.data, firebaseAuth: widget.firebaseAuth!, isGoogle: true)));
        }
      },
      builder: (context, state1) {
        return BlocConsumer<LoginCubit, NetworkState<User>>(
          listener: (context, state) {
            if (state is Error<User>) {
              context.flushBarErrorMessage(message: state.message);
            } else if (state is Success<User>) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => StartQuiz(user: state.data, firebaseAuth: widget.firebaseAuth!, isGoogle: false)));
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Stack(
                children: [
                  Scaffold(
                    body: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.blueColor, AppColors.greyColor],
                        ),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _header(),
                                  const SizedBox(height: 48),
                                  _inputField(),
                                  const SizedBox(height: 24),
                                  _googleSignInButton(),
                                  const SizedBox(height: 24),
                                  _forgotPassword(),
                                  const SizedBox(height: 24),
                                  _signup(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (state is Loading<User> || state1 is Loading<User>) ...[LoadingWidget()]
                ],
              ),
            );
          },
        );
      },
    );
  }

  _header() {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: Global.customFonts(size: 32, weight: FontWeight.bold, color: AppColors.whiteColor, family: 'poppins2'),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your credentials to login",
          style: Global.customFonts(size: 18, color: AppColors.whiteColor),
        ),
      ],
    );
  }

  _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: _inputDecoration('Email', Icons.email),
          style: Global.customFonts(size: 16, color: AppColors.whiteColor),
          validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
          onSaved: (newValue) => _email = newValue ?? '',
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: _inputDecoration('Password', Icons.lock, flag: true),
          style: Global.customFonts(size: 16, color: AppColors.whiteColor),
          obscureText: !isVisible,
          validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
          onSaved: (newValue) => _password = newValue ?? '',
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => login(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            "Login",
            style: Global.customFonts(size: 16, color: AppColors.blueColor, weight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  _forgotPassword() {
    return TextButton(
      onPressed: () {},
      child: Text(
        "Forgot password?",
        style: Global.customFonts(size: 18, weight: FontWeight.bold, color: AppColors.whiteColor),
      ),
    );
  }

  _signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: Global.customFonts(size: 18, color: AppColors.whiteColor),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
          child: Text(
            "Sign Up",
            style: Global.customFonts(size: 18, family: 'poppins2', color: AppColors.whiteColor),
          ),
        )
      ],
    );
  }

  _googleSignInButton() {
    return Column(
      children: [
        Text(
          "Or",
          style: Global.customFonts(size: 18, color: AppColors.whiteColor, weight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<GoogleSignInCubit>().getGoogleSignIn(widget.firebaseAuth);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: Image.asset('assets/images/google.png', height: 32),
            label: Text(
              "Sign In with Google",
              style: Global.customFonts(size: 12, color: AppColors.blackColor),
            ),
          ),
        ),
      ],
    );
  }

  _inputDecoration(String hint, IconData icon, {bool? flag = false}) {
    return InputDecoration(
      suffixIcon: flag!
          ? GestureDetector(
              onTap: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.whiteColor,
              ),
            )
          : null,
      prefixIcon: Icon(
        icon,
        color: AppColors.whiteColor,
      ),
      hintText: hint,
      hintStyle: Global.customFonts(size: 18, color: AppColors.whiteColor),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.greyColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
