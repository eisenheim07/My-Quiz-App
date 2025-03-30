import 'package:bloc/bloc.dart';

import '../../common/network.dart';
import '../repo/AppRepo.dart';

class SignoutCubit extends Cubit<NetworkState<String>> {
  final AppRepo appRepo;

  SignoutCubit(this.appRepo) : super(Initial());

  Future<void> getUserSignout() async {
    emit(Loading());
    final result = await appRepo.getUserSignout();
    emit(result);
  }
}