import 'package:bloc/bloc.dart';
import 'package:quizapp/businesslogic/models/ChatModel.dart';

import '../../common/network.dart';
import '../repo/AppRepo.dart';

class ChatCubit extends Cubit<NetworkState<ChatModel>> {
  final AppRepo appRepo;

  ChatCubit(this.appRepo) : super(Initial());

  Future<void> fetchData(String json) async {
    emit(Loading());
    final result = await appRepo.getChat(json);
    emit(result);
  }
}
