import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../common/global.dart';

class ResultPage extends StatefulWidget {
  final Map<String, String> resultMap;

  const ResultPage({super.key, required this.resultMap});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int correct = 0;
  List<String> correctAnswer = [];
  List<String> userAnswer = [];

  @override
  void initState() {
    super.initState();

    int count = 0;
    widget.resultMap.forEach((question, answer) {
      if (question == answer) {
        count++;
      }
    });

    correct = count;
    correctAnswer = widget.resultMap.keys.toList();
    userAnswer = widget.resultMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.blueColor, AppColors.greyColor],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Quiz Results',
                    style: Global.customFonts(
                      size: 32,
                      weight: FontWeight.bold,
                      color: AppColors.whiteColor,
                      family: 'poppins2',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$correct',
                          style: Global.customFonts(
                            size: 48,
                            weight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        Text(
                          'out of ${widget.resultMap.length} correct',
                          style: Global.customFonts(
                            size: 16,
                            weight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue.shade800,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.refresh, color: AppColors.blueColor),
                    label: Text(
                      'Retake Quiz',
                      style: Global.customFonts(
                        size: 16,
                        weight: FontWeight.bold,
                        color: AppColors.blueColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Summary',
                  style: Global.customFonts(
                    size: 24,
                    weight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.resultMap.length,
                    itemBuilder: (context, index) {
                      bool isCorrect = correctAnswer[index] == userAnswer[index];
                      return Card(
                        color: isCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                          title: Text(
                            correctAnswer[index],
                            style: Global.customFonts(
                              size: 16,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Your Answer: ${userAnswer[index]}',
                            style: Global.customFonts(
                              size: 14,
                              color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
