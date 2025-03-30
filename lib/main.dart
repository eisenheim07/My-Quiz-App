import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/root_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final preffs = await SharedPreferences.getInstance();
  runApp(RootApp(preffs: preffs));
}
