import 'package:bloc/bloc.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

import '../../common/network.dart';
import '../repo/AppRepo.dart';

class UserDetailsCubit extends Cubit<NetworkState<QuerySnapshot<Map<String, dynamic>>>> {
  final AppRepo appRepo;

  UserDetailsCubit(this.appRepo) : super(Initial());

  Future<void> getUserDetails(String uuid) async {
    emit(Loading());
    final result = await appRepo.getUserDetails(uuid);
    emit(result);
  }
}