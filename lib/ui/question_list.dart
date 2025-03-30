import 'package:quizapp/businesslogic/models/QuestionModel.dart';

class QuestionsClass {
  final String data;

  QuestionsClass({required this.data});

  List<QuestionModel> questions() {
    List<QuestionModel> questions = parseQuestions(data);
    return questions;
  }
}
