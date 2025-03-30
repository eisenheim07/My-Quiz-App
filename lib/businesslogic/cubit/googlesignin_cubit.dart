import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/network.dart';
import '../repo/AppRepo.dart';

class GoogleSignInCubit extends Cubit<NetworkState<User>> {
  final AppRepo appRepo;

  GoogleSignInCubit(this.appRepo) : super(Initial());

  Future<void> getGoogleSignIn(FirebaseAuth? firebaseAuth) async {
    emit(Loading());
    final result = await appRepo.getGoogleSignIn(firebaseAuth);
    emit(result);
  }
}