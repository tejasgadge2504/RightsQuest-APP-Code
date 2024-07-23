import 'package:flutter/material.dart';
import 'package:moralmentor/Screens/quiz.dart';

class LevelsPage extends StatefulWidget {
  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {
  final TextEditingController _controller = TextEditingController();
  final Map<String, List<String>> rightsCategories = {
    'Basic Rights': [
      'Right to Life',
      'Right to Education',
      'Right to Food',
      'Right to Shelter',
      'Right to Health'
    ],
    'Social Justice': [
      'Right to Equality',
      'Right to Freedom from Discrimination',
      'Right to Social Security',
      'Right to Work',
      'Right to Participate in Cultural Life'
    ],
    'Civil and Political Rights': [
      'Right to Freedom of Speech',
      'Right to Freedom of Assembly',
      'Right to Freedom of Religion',
      'Right to Privacy',
      'Right to Vote'
    ],
    "Children's Rights": [
      'Right to Protection from Abuse and Exploitation',
      'Right to Family and Parental Care',
      'Right to Education and Development',
      'Right to Play and Recreation',
      'Right to Express Opinions'
    ],
  };

  // Map to store progress for each right
  Map<String, bool> rightsProgress = {};

  @override
  void initState() {
    super.initState();
    _initializeProgress();
  }

  void _initializeProgress() {
    // Initialize progress for all rights as false
    for (var rights in rightsCategories.values) {
      for (var right in rights) {
        rightsProgress[right] = false;
      }
    }
  }

  void _searchOrAddRight(BuildContext context) async {
    String searchText = _controller.text.trim();
    bool found = false;

    // Check if the right exists in the predefined categories
    for (var category in rightsCategories.values) {
      if (category.contains(searchText)) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
              rightName: searchText,
              onCompletion: () => _updateProgress(searchText),
            ),
          ),
        );

        // Update progress based on result
        if (result != null && result) {
          _updateProgress(searchText);
        }

        found = true;
        break;
      }
    }

    if (!found) {
      // If not found, add the new right and navigate to the quiz page
      setState(() {
        String defaultCategory = 'Custom Rights';
        if (!rightsCategories.containsKey(defaultCategory)) {
          rightsCategories[defaultCategory] = [];
        }
        rightsCategories[defaultCategory]!.add(searchText);
      });

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
            rightName: searchText,
            onCompletion: () => _updateProgress(searchText),
          ),
        ),
      );

      // Update progress based on result
      if (result != null && result) {
        _updateProgress(searchText);
      }
    }
  }

  void _updateProgress(String rightName) {
    setState(() {
      rightsProgress[rightName] = true; // Mark the right as completed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Level'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter a right to study',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _searchOrAddRight(context),
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rightsCategories.length,
              itemBuilder: (context, categoryIndex) {
                String category = rightsCategories.keys.elementAt(categoryIndex);
                List<String> rights = rightsCategories[category]!;
                int completedRights = rights.where((right) => rightsProgress[right] == true).length;
                double progress = rights.isNotEmpty ? completedRights / rights.length : 0.0;

                return ExpansionTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(category)),
                      SizedBox(width: 10),
                      Container(
                        width: 100,
                        height: 10,
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('${(progress * 100).toStringAsFixed(0)}%'),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...rights.map((right) {
                            return ListTile(
                              title: Text(right),
                              trailing: rightsProgress[right] == true
                                  ? Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return QuizPage(
                                        rightName: right,
                                        onCompletion: () => _updateProgress(right),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
