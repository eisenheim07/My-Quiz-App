import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizapp/businesslogic/models/ChatModel.dart';
import 'package:quizapp/common/preffs_manager.dart';

import '../../common/config.dart';
import '../../common/network.dart';
import '../chopper/ApiService.dart';

class AppRepo {
  final ApiService apiService;
  final PreferenceManager preffs;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseStore;

  AppRepo(this.apiService, this.preffs, this._firebaseAuth, this._firebaseStore);

  Future<NetworkState<UserCredential>> getUserSignup(Map<String, dynamic> map) async {
    try {
      var data = await _firebaseAuth.createUserWithEmailAndPassword(
        email: map['email'],
        password: map['password'],
      );
      if (data.user != null) {
        await _firebaseStore.collection(Config.DB_NAME).doc(data.user!.uid).set({
          "firstName": map['firstName'],
          "lastName": map['lastName'],
          "username": "${map['firstName']} ${map['lastName']}",
          "phoneNumber": map['phoneNumber'],
          "email": map['email'],
          "password": map['password'],
          "uuid": data.user!.uid,
          "isVerified": data.user!.emailVerified,
          "createdAt": DateTime.now().toString(),
          "profilePic": "",
          "userStatus": "NONE"
        });
        _firebaseAuth.signOut();
      } else {
        return Error("Something went wrong, User not registered.");
      }
      return Success(data);
    } catch (e) {
      return Error("Something went wrong, ${e.toString()}.");
    }
  }

  Future<NetworkState<User>> getGoogleSignIn(FirebaseAuth? firebaseAuth) async {
    try {
      var googleUser = await GoogleSignIn().signIn();
      var auth = await googleUser!.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      var result = await firebaseAuth?.signInWithCredential(credentials);
      if (result!.user != null) {
        preffs.putBoolean(Config.IS_GOOGLE, true);
        return Success(result.user!);
      } else {
        return Error("Something went wrong, try again.");
      }
    } catch (e) {
      return Error("Something went wrong: ${e.toString()}.");
    }
  }

  Future<NetworkState<User>> getUserSignIn(Map<String, dynamic> map) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(email: map['email'], password: map['password']);
      if (result.user != null) {
        preffs.putBoolean(Config.IS_GOOGLE, false);
        return Success(result.user!);
      } else {
        return Error("Something went wrong, try again.");
      }
    } catch (e) {
      return Error("Something went wrong, ${e.toString()}.");
    }
  }

  Future<NetworkState<ChatModel>> getChat(String json) async {
    try {
      var data = await apiService.getHome(json, 'Bearer ${Config.TOKEN}');
      if (data.isSuccessful && data.statusCode == 200) {
        return Success(chatModelFromJson(data.body.toString()));
      } else {
        return Error("Something went wrong, ${data.statusCode}.");
      }
    } catch (e) {
      return Error("Something went wrong: ${e.toString()}.");
    }
  }

  Future<NetworkState<String>> getUserSignout() async {
    try {
      await _firebaseAuth.signOut();
      preffs.clear();
      return Success('logout');
    } catch (e) {
      return Error("Something went wrong: ${e.toString()}.");
    }
  }

  Future<NetworkState<QuerySnapshot<Map<String, dynamic>>>> getUserDetails(String uuid) async {
    try {
      var result = await _firebaseStore.collection(Config.DB_NAME).where("uuid", isEqualTo: uuid).get();
      if (result.size > 0) {
        return Success(result);
      } else {
        return Error("Something went wrong, User not exists.");
      }
    } catch (e) {
      return Error("Something went wrong: ${e.toString()}.");
    }
  }
}
