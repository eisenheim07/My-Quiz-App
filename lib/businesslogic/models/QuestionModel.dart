import 'dart:convert';

class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswerIndexValue;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswerIndexValue,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndexValue: json['correctAnswerIndexValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndexValue': correctAnswerIndexValue,
    };
  }
}

List<QuestionModel> parseQuestions(String jsonString) {
  List<dynamic> decodedJson = jsonDecode(jsonString);
  return decodedJson.map((json) => QuestionModel.fromJson(json)).toList();
}