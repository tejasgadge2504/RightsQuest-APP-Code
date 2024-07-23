import 'package:flutter/material.dart';
import 'package:moralmentor/Screens/levels.dart';
import 'dart:math';  // for shuffling the options

import '../requests/ApiService.dart';

class QuizPage extends StatefulWidget {
  final String rightName;
  final VoidCallback? onCompletion;

  QuizPage({required this.rightName, this.onCompletion});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<Map<String, dynamic>> futureQuizData;
  List<bool> _isSelected = [false, false, false, false];
  String? feedback;
  int points = 0;
  bool feedbackGiven = false;
  List<String> _optionTexts = [];
  Map<String, int> _pointsMapping = {}; // Mapping of option text to points

  @override
  void initState() {
    super.initState();
    futureQuizData = fetchQuizData(widget.rightName);
  }

  Future<Map<String, dynamic>> fetchQuizData(String rightName) async {
    ApiService apiService = ApiService();
    print(rightName);
    return await apiService.fetchQuizData(rightName);
  }

  void showFeedbackDialog(String feedback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feedback'),
          content: Text(feedback),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  feedbackGiven = true;
                });
                Navigator.of(context).pop();
                if (widget.onCompletion != null) {
                  widget.onCompletion!();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void updatePoints(String selectedOption) {
    points += _pointsMapping[selectedOption] ?? 0;
  }

  void shuffleOptions() {
    _optionTexts.shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              onTap: () {
                // Direct To Profile Page on Tap
              },
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureQuizData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading for you most suitable scenarios'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/ErrorRobot.png', height: 150,),
                  SizedBox(height: 20),
                  Text('Error: ${snapshot.error}', style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            var quizData = snapshot.data!;
            var story = quizData['Story'] ?? 'No story available';
            var scenario = quizData['Scenario'] ?? 'No scenario available';
            var mostPositive = quizData['most_positive'] ?? 'No option available';
            var positive = quizData['positive'] ?? 'No option available';
            var neutral = quizData['neutral'] ?? 'No option available';
            var negative = quizData['negative'] ?? 'No option available';
            var feedback = quizData['feedback'] ?? 'No feedback available';

            _optionTexts = [mostPositive, positive, neutral, negative];
            _pointsMapping = {
              mostPositive: 3,
              positive: 2,
              neutral: 1,
              negative: 0,
            };

            shuffleOptions();  // Shuffle options here

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade200,
                              ),
                              child: Text(
                                story,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ...List.generate(
                            _optionTexts.length,
                                (index) => Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Radio(
                                    value: index,
                                    groupValue: _isSelected.indexOf(true),
                                    onChanged: feedbackGiven ? null : (int? value) {
                                      setState(() {
                                        _isSelected = List.generate(_isSelected.length, (i) => i == index);
                                        updatePoints(_optionTexts[index]);
                                        showFeedbackDialog(feedback!);
                                        if (widget.onCompletion != null) {
                                          widget.onCompletion!();
                                        }
                                      });
                                    },
                                  ),
                                  Expanded(child: Text(_optionTexts[index])),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (feedbackGiven) ...[
                      SizedBox(height: 20),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Points: $points',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LevelsPage()),
                          );
                        },
                        child: Text('Next'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
