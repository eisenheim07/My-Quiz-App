import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/businesslogic/cubit/signup_cubit.dart';
import 'package:quizapp/common/flushbar.dart';
import 'package:quizapp/ui/login_page.dart';

import '../common/colors.dart';
import '../common/global.dart';
import '../common/network.dart';
import '../widgets/loading_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formkey = GlobalKey<FormState>();
  var isFormValid = false;
  var isVisible = false;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneNoController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void signUp() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      var map = {
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "phoneNumber": phoneNoController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };
      context.read<SignupCubit>().getUserSignup(map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, NetworkState<UserCredential>>(
      listener: (context, state) {
        if (state is Error<UserCredential>) {
          context.flushBarErrorMessage(message: state.message);
        } else if (state is Success<UserCredential>) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Container(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _header(),
                            const SizedBox(height: 48),
                            _form(),
                            const SizedBox(height: 24),
                            _googleSignInButton(),
                            const SizedBox(height: 24),
                            _loginLink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (state is Loading<UserCredential>) ...[LoadingWidget()]
              ],
            ),
          ),
        );
      },
    );
  }

  _header() {
    return Column(
      children: [
        Text(
          "Sign Up",
          style: Global.customFonts(size: 32, color: AppColors.whiteColor, weight: FontWeight.bold, family: 'poppins2'),
        ),
        const SizedBox(height: 8),
        Text(
          "Create your account",
          style: Global.customFonts(size: 18, color: AppColors.whiteColor),
        ),
      ],
    );
  }

  _form() {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: firstNameController,
                  style: Global.customFonts(size: 16, color: AppColors.whiteColor),
                  validator: (value) => value!.length < 3 ? 'Invalid First Name.' : null,
                  keyboardType: TextInputType.text,
                  decoration: _inputDecoration('First Name', Icons.abc_outlined),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: TextFormField(
                  controller: lastNameController,
                  style: Global.customFonts(size: 16, color: AppColors.whiteColor),
                  validator: (value) => value!.length < 2 ? 'Invalid Lastname' : null,
                  keyboardType: TextInputType.text,
                  decoration: _inputDecoration('Last Name', Icons.abc_outlined),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextFormField(
            style: Global.customFonts(size: 16, color: AppColors.whiteColor),
            controller: phoneNoController,
            validator: (value) => value!.length < 10 ? 'Invalid Phone Number' : null,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: _inputDecoration('Enter Phone Number', Icons.phone),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: emailController,
            style: Global.customFonts(size: 16, color: AppColors.whiteColor),
            validator: (value) => value!.isEmpty ? 'Enter valid Email' : null,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('Enter Email Address', Icons.email),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: passwordController,
            style: Global.customFonts(size: 16, color: AppColors.whiteColor),
            obscureText: !isVisible,
            validator: (value) => value!.length < 10 ? 'Invalid Password' : null,
            decoration: _inputDecoration('Enter Password', Icons.password, flag: true),
          ),
          SizedBox(height: 22),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => signUp(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Signup",
                style: Global.customFonts(size: 16, color: AppColors.blueColor, weight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _googleSignInButton() {
    return Column(
      children: [
        Text(
          "Or",
          style: Global.customFonts(size: 18, color: AppColors.whiteColor, weight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
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

  Widget _loginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: RichText(
            text: TextSpan(
              text: "Already Have Account? ",
              style: Global.customFonts(size: 18, color: AppColors.whiteColor),
              children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
                    text: 'SignIn',
                    style: Global.customFonts(size: 18, color: AppColors.whiteColor, family: 'poppins2')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
