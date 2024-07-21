import 'package:flutter/material.dart';
import '../requests/ApiService.dart';

class QuizPage extends StatefulWidget {
  final String rightName;

  QuizPage({required this.rightName});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<Map<String, dynamic>> futureQuizData;
  List<bool> _isSelected = [false, false, false, false];
  String? feedback;
  int points = 0;

  @override
  void initState() {
    super.initState();
    futureQuizData = fetchQuizData(widget.rightName);
  }

  Future<Map<String, dynamic>> fetchQuizData(String rightName) async {
    ApiService apiService = ApiService();
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updatePoints(int index) {
    if (index == 0) {
      points += 3;
    } else if (index == 1) {
      points += 2;
    } else if (index == 2) {
      points += 1;
    } // No points for index 3 as it is negative outcome
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Image.asset("assets/images/RightsQuest_logo.png", width: 170,),
            // SizedBox(width: size.width * 0.3),
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
                  // Image.asset('images/LoadingRobot.gif',height: 150,), // Replace with your GIF asset path
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
                  Image.asset('assets/images/ErrorRobot.png', height: 150,), // Replace with your GIF asset path
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
            List<String> _optionTexts = [
              mostPositive,
              positive,
              neutral,
              negative,
            ];

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          // Image.asset('assets/images/QuestionAvtar.png', width: 30,),
                          // SizedBox(width: size.width * 0.05,),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.greenAccent.shade100,
                                    offset: const Offset(5.0, 5.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ),
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  story,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.05,),
                    Row(
                      children: [
                        Text('Scenario :', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: size.width * 0.65,),
                        // Text("1/3", style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01,),
                    Text(
                      scenario,
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue, fontSize: 14),
                    ),
                    SizedBox(height: size.height * 0.01,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isSelected = [false, false, false, false];
                                _isSelected[index] = !_isSelected[index];
                                feedback = quizData['feedback'];
                                showFeedbackDialog(feedback!);
                                updatePoints(index);
                              });
                            },
                            child: Container(
                              constraints: BoxConstraints(minHeight: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  width: 2,
                                  color: _isSelected[index]
                                      ? index == 0
                                      ? Colors.green
                                      : index == 1 || index == 2
                                      ? Colors.yellow.shade800
                                      : Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  _optionTexts[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _isSelected[index]
                                        ? index == 0
                                        ? Colors.green
                                        : index == 1 || index == 2
                                        ? Colors.yellow.shade800
                                        : Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: size.height * 0.05,),
                    ElevatedButton(
                      onPressed: () {
                        // Handle submission logic here, e.g., navigate to the next screen or display a summary
                      },
                      child: Text('Submit'),
                    ),
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
