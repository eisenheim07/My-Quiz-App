import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/network.dart';
import '../repo/AppRepo.dart';

class SignupCubit extends Cubit<NetworkState<UserCredential>> {
  final AppRepo appRepo;

  SignupCubit(this.appRepo) : super(Initial());

  Future<void> getUserSignup(Map<String, dynamic> map) async {
    emit(Loading());
    final result = await appRepo.getUserSignup(map);
    emit(result);
  }
}