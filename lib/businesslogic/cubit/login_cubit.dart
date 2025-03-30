import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/network.dart';
import '../repo/AppRepo.dart';

class LoginCubit extends Cubit<NetworkState<User>> {
  final AppRepo appRepo;

  LoginCubit(this.appRepo) : super(Initial());

  Future<void> getUserLogin(Map<String, dynamic> map) async {
    emit(Loading());
    final result = await appRepo.getUserLogin(map);
    emit(result);
  }
}