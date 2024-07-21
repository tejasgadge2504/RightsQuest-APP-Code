import 'package:flutter/material.dart';
import 'package:moralmentor/Screens/quiz.dart';
// import 'QuizPage.dart';

class LevelsPage extends StatelessWidget {
  final List<String> levels = ['Right to Freedom', 'Right to Education', 'Right to Equality'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Level'),
      ),
      body: ListView.builder(
        itemCount: levels.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(levels[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(rightName: levels[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
