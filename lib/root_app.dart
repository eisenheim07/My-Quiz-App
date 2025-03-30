import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logging/logging.dart' as inspector;
import 'package:quizapp/businesslogic/cubit/googlesignin_cubit.dart';
import 'package:quizapp/businesslogic/cubit/login_cubit.dart';
import 'package:quizapp/businesslogic/cubit/signup_cubit.dart';
import 'package:quizapp/businesslogic/cubit/userdetails_cubit.dart';
import 'package:quizapp/ui/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'businesslogic/chopper/ApiService.dart';
import 'businesslogic/cubit/chat_cubit.dart';
import 'businesslogic/cubit/signout_cubit.dart';
import 'businesslogic/repo/AppRepo.dart';
import 'common/colors.dart';
import 'common/preffs_manager.dart';
import 'common/theme.dart';

class RootApp extends StatefulWidget {
  final SharedPreferences preffs;

  const RootApp({super.key, required this.preffs});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  final apiService = ApiService.create();
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    inspector.Logger.root.level = inspector.Level.ALL;
    inspector.Logger.root.onRecord.listen((record) {
      log('${record.level.name}: ${record.time}: ${record.message}');
    });
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final preffs = PreferenceManager(widget.preffs);
        final appRepo = AppRepo(apiService, preffs, _firebaseAuth, _firebaseStore);
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ChatCubit(appRepo)),
            BlocProvider(create: (context) => SignupCubit(appRepo)),
            BlocProvider(create: (context) => GoogleSignInCubit(appRepo)),
            BlocProvider(create: (context) => LoginCubit(appRepo)),
            BlocProvider(create: (context) => UserDetailsCubit(appRepo)),
            BlocProvider(create: (context) => SignoutCubit(appRepo)),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: AppTheme.lightTheme,
            home: SplashPage(preffs: preffs, firebaseAuth: _firebaseAuth),
          ),
        );
      },
    );
  }
}
