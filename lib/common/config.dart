class Config {
  static const String BASE_URL = "https://api.groq.com/openai/v1/";
  static const String GET_CONVERSATION = "chat/completions";
  static const TOKEN = "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";
  static const DB_NAME = "quizapp";

  static getPrompt(String level, String category) {
    return "Generate 5 unique & $level multiple-choice questions, must be different every time, about $category. Each question must have 4 options and an acknowledged correct answer. Format response as JSON: [{\"question\": \"...\", \"options\": [\"...\", \"...\", \"...\", \"...\"], \"correctAnswerIndexValue\": X}]";
  }
}
