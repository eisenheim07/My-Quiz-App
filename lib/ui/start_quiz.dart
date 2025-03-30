import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/businesslogic/cubit/chat_cubit.dart';
import 'package:quizapp/businesslogic/cubit/userdetails_cubit.dart';
import 'package:quizapp/businesslogic/models/ChatModel.dart';
import 'package:quizapp/common/flushbar.dart';
import 'package:quizapp/common/network.dart';
import 'package:quizapp/ui/login_page.dart';
import 'package:quizapp/ui/question_page.dart';
import 'package:quizapp/widgets/loading_widget.dart';

import '../businesslogic/cubit/signout_cubit.dart';
import '../common/colors.dart';
import '../common/config.dart';
import '../common/global.dart';

class StartQuiz extends StatefulWidget {
  final User user;
  final FirebaseAuth? firebaseAuth;

  const StartQuiz({super.key, required this.user, this.firebaseAuth});

  @override
  State<StartQuiz> createState() => _StartQuizState();
}

class _StartQuizState extends State<StartQuiz> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> categories = ['Science & Technology', 'History', 'Engineering', 'Travel', 'Business', 'Share Market', 'Foreign'];
  final List<String> level = ['Easy', 'Intermediate', 'Difficult'];

  String? selectedCategory, selectLevel;

  Map<String, dynamic>? userMap;

  @override
  void initState() {
    context.read<UserDetailsCubit>().getUserDetails(widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignoutCubit, NetworkState<String>>(
      listener: (context, state) {
        if (state is Error<String>) {
          context.flushBarErrorMessage(message: state.message);
        } else if (state is Success<String>) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      },
      builder: (context, state2) {
        return BlocConsumer<UserDetailsCubit, NetworkState<QuerySnapshot<Map<String, dynamic>>>>(
          listener: (context, state) {
            if (state is Error<QuerySnapshot<Map<String, dynamic>>>) {
              context.flushBarErrorMessage(message: state.message);
            } else if (state is Success<QuerySnapshot<Map<String, dynamic>>>) {
              userMap = state.data.docs[0].data();
            }
          },
          builder: (context, state1) {
            return BlocConsumer<ChatCubit, NetworkState<ChatModel>>(
              listener: (context, state) {
                if (state is Error<ChatModel>) {
                  context.flushBarErrorMessage(message: state.message);
                } else if (state is Success<ChatModel>) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => QuestionPage(data: state.data.choices!.first.message!.content.toString())));
                }
              },
              builder: (context, state) {
                return SafeArea(
                  child: Scaffold(
                    key: _scaffoldKey,
                    drawer: customDrawer(),
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
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              _scaffoldKey.currentState!.openDrawer();
                                            },
                                            child: Icon(Icons.menu, size: 32, color: AppColors.whiteColor)),
                                        SizedBox(width: 4),
                                        Text(
                                          'Hi ${widget.user.displayName != null && widget.user.displayName != '' ? widget.user.displayName : 'Champ'},',
                                          style:
                                              Global.customFonts(size: 22, weight: FontWeight.bold, color: AppColors.whiteColor, family: 'poppins2'),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        context.read<SignoutCubit>().getUserSignout();
                                      },
                                      icon: const Icon(Icons.logout, color: Colors.blue),
                                      label: Text(
                                        'Logout',
                                        style: Global.customFonts(size: 12, weight: FontWeight.bold, color: AppColors.blueColor),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(0.2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.1),
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Image.asset(
                                              'assets/images/quiz.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                        Text(
                                          "Learn with Flutter",
                                          style: Global.customFonts(size: 32, weight: FontWeight.bold, color: AppColors.whiteColor, family: 'poppins2'),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "Test your knowledge and improve your skills!",
                                          textAlign: TextAlign.center,
                                          style: Global.customFonts(size: 18, weight: FontWeight.bold, color: AppColors.whiteColor),
                                        ),
                                        const SizedBox(height: 40),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: selectedCategory,
                                                hint: Text(
                                                  "Select Category",
                                                  style: Global.customFonts(size: 16, weight: FontWeight.bold, color: AppColors.blueColor),
                                                ),
                                                isExpanded: true,
                                                icon: Icon(Icons.arrow_drop_down, color: AppColors.blueColor, size: 28),
                                                style: Global.customFonts(size: 16, weight: FontWeight.bold, color: AppColors.blueColor),
                                                borderRadius: BorderRadius.circular(20),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedCategory = newValue;
                                                  });
                                                },
                                                items: categories.map<DropdownMenuItem<String>>((String category) {
                                                  return DropdownMenuItem<String>(
                                                    value: category,
                                                    child: Text(category),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: selectLevel,
                                                hint: Text(
                                                  "Select Level",
                                                  style: Global.customFonts(size: 16, weight: FontWeight.bold, color: AppColors.blueColor),
                                                ),
                                                isExpanded: true,
                                                icon: Icon(Icons.arrow_drop_down, color: AppColors.blueColor, size: 28),
                                                style: Global.customFonts(size: 16, weight: FontWeight.bold, color: AppColors.blueColor),
                                                borderRadius: BorderRadius.circular(20),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectLevel = newValue;
                                                  });
                                                },
                                                items: level.map<DropdownMenuItem<String>>((String category) {
                                                  return DropdownMenuItem<String>(
                                                    value: category,
                                                    child: Text(category),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 40),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state is Loading<ChatModel> || state1 is Loading<QuerySnapshot<Map<String, dynamic>>> || state2 is Loading<String>) ...[
                          LoadingWidget()
                        ]
                      ],
                    ),
                    bottomNavigationBar: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedCategory == null) {
                            context.flushBarErrorMessage(message: "Please select Category first.");
                          } else if (selectLevel == null) {
                            context.flushBarErrorMessage(message: "Please select Level.");
                          } else {
                            var map = {
                              "model": "llama-3.3-70b-versatile",
                              "messages": [
                                {
                                  "role": "user",
                                  "content": Config.getPrompt(selectLevel!, selectedCategory!)
                                }
                              ]
                            };
                            var json = jsonEncode(map);
                            context.read<ChatCubit>().fetchData(json);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Start Quiz',
                              style: Global.customFonts(
                                  size: 18,
                                  weight: FontWeight.bold,
                                  color: (selectLevel != null && selectedCategory != null) ? AppColors.blueColor : AppColors.greyColor),
                            ),
                            const SizedBox(width: 10),
                            Icon(Icons.arrow_forward_rounded,
                                size: 24, color: (selectLevel != null && selectedCategory != null) ? AppColors.blueColor : AppColors.greyColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget customDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.blueColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.user.email.toString(),
                            style: Global.customFonts(size: 14, weight: FontWeight.bold, color: AppColors.whiteColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (userMap != null) ...[
                    row('First Name : ', userMap!['firstName'] ?? 'None'),
                    row('Last Name : ', userMap!['lastName'] ?? 'None'),
                    row('Username : ', userMap!['username'] ?? 'None'),
                    row('Phone : ', userMap!['phoneNumber'] ?? 'None'),
                    row('UUID : ', userMap!['uuid'] ?? 'None'),
                    row('Created At : ', userMap!['createdAt'] ?? 'None'),
                  ] else ...[
                    row('First Name : ', 'None'),
                    row('Last Name : ', 'None'),
                    row('Username : ', 'None'),
                    row('Phone : ', 'None'),
                    row('UUID : ', 'None'),
                    row('Created At : ', 'None'),
                  ],
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        toggleDrawer();
                        context.read<SignoutCubit>().getUserSignout();
                      },
                      icon: const Icon(Icons.logout, color: Colors.blue),
                      label: Text(
                        'Logout',
                        style: Global.customFonts(size: 12, weight: FontWeight.bold, color: AppColors.blueColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.scaffoldColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    }
  }

  row(String title, String value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: Global.customFonts(size: 12, weight: FontWeight.bold, color: AppColors.blueColor, family: 'poppins2'),
          ),
        ),
        Global.horizontalSpace(context, 0.1),
        Expanded(
          flex: 2,
          child: Text(
            overflow: TextOverflow.ellipsis,
            value,
            style: Global.customFonts(size: 16, color: AppColors.blueColor),
          ),
        )
      ],
    );
  }
}
