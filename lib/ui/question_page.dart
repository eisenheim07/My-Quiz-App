import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quizapp/ui/question_list.dart';
import 'package:quizapp/ui/result_screen.dart';

import '../common/colors.dart';
import '../common/global.dart';

class QuestionPage extends StatefulWidget {
  final String data;

  const QuestionPage({super.key, required this.data});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  var currentIndex = 0;
  var selectedValue = "None";
  Map<String, String> map = {};

  Timer? timer;
  int timeLeft = 30;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  moveToNextQuestion() {
    var question = QuestionsClass(data: widget.data).questions();
    var index = question[currentIndex].correctAnswerIndexValue;
    var key = question[currentIndex].options[index];
    map[key] = selectedValue;
    if (currentIndex < QuestionsClass(data: widget.data).questions().length - 1) {
      setState(() {
        currentIndex++;
        selectedValue = "None";
      });
      startTimer();
    } else {
      timer?.cancel();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage(resultMap: map)));
    }
  }

  startTimer() {
    timer?.cancel();
    timeLeft = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        moveToNextQuestion();
      }
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var instance = QuestionsClass(data: widget.data);
    var data = instance.questions();
    List<String> shuffledNumbers = List.from(data[currentIndex].options)..shuffle(Random());
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.blueColor, AppColors.greyColor],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: (currentIndex + 1) / data.length,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question  ${currentIndex + 1}/${data.length}',
                      style: Global.customFonts(size: 16, weight: FontWeight.bold, color: AppColors.whiteColor),
                      textAlign: TextAlign.center,
                    ),
                    Text("Time Remaining : ${timeLeft.toString()}", style: Global.customFonts(size: 16, weight: FontWeight.bold, color: AppColors.whiteColor))
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      data[currentIndex].question,
                      style: Global.customFonts(size: 18, weight: FontWeight.bold, color: AppColors.blueColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    children: data[currentIndex]
                        .options
                        .map(
                          (options) => AnswerButton(
                              options,
                              () => {
                                    setState(() {
                                      selectedValue = options;
                                    })
                                  },
                              selectedValue == options ? AppColors.greyColor : AppColors.whiteColor),
                        )
                        .toList(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    moveToNextQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue.shade800,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentIndex != 4 ? 'Next' : 'Submit',
                        style: Global.customFonts(size: 18, weight: FontWeight.bold, color: AppColors.blueColor),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward_rounded, size: 24, color: AppColors.blueColor),
                    ],
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

class AnswerButton extends StatelessWidget {
  const AnswerButton(this.options, this.onTap, this.bgColor, {super.key});

  final Color bgColor;
  final String options;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        onPressed: onTap,
        child: Text(
          options,
          style: Global.customFonts(
            size: 18,
            weight: FontWeight.bold,
            color: bgColor == AppColors.whiteColor ? AppColors.blueColor : AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
