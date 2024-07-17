import 'package:flutter/material.dart';
import 'package:moralmentor/src/colors.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<bool> _isSelected = [false, false, false, false];
  List<String> _optionTexts = ["Supporting families in finding safe housing", "Occasionally offering housing assistance", "Neglecting housing support services", "Ignoring housing needs"];
  List<int> _internalLabels = [3, 2, 1, 0]; // Internal labels for the buttons

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/images/RightsQuest_logo.png",width: 170,),
            // Text(
            //   "RightsQuest",
            //   style: TextStyle(
            //     color: AppBarTextColor.shade600,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 25,
            //   ),
            // ),
            SizedBox(width: size.width * 0.3),
            InkWell(
              onTap: () {
                // Direct To Profile Page on Tap
              },
              child: Icon(Icons.person, color: AppBarTextColor),
            ),
          ],
        ),
        backgroundColor: AppBarColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(

                child: Row(
                  children: [
                    Image.asset('assets/images/QuestionAvtar.png',width: 130,),
                    SizedBox(width: size.width*0.05,),
                    Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                        BoxShadow(
                        color: Colors.greenAccent.shade100,
                          offset: const Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ), //BoxShadow
                        BoxShadow(
                          color: Colors.white,
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                        ],
                          borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 2,
                              color: Colors.grey,


                            )
                        ),
                      width: 170,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('In an urban area, low-income families live in overcrowded and unsafe housing conditions.',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                        )),
                  ],
                ),
              ),
              SizedBox(height: size.height*0.05,),
              Row(
                children: [
                  Text('Scenario :',style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: size.width*0.65,),
                  Text("1/3",style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: size.height*0.01,),
              Text('Non-profit organizations provide housing assistance and support services. What happens?',style: TextStyle(fontWeight: FontWeight.w600,color: AppTextBlue,fontSize: 14),),
              SizedBox(height: size.height*0.01,),
              // Text('Choose Suitable options below:'),
              // SizedBox(height: size.height*0.01,),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isSelected[index] = !_isSelected[index];
                        });
                        print(_internalLabels[index]);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            width: 2,
                            color: _isSelected[index]
                                ? _internalLabels[index] == 3
                                ? Colors.green
                                : _internalLabels[index] == 2 || _internalLabels[index] == 1
                                ? Colors.yellow.shade800
                                : Colors.red
                                : Colors.grey,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _optionTexts[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isSelected[index]
                                ? _internalLabels[index] == 3
                                ? Colors.green
                                : _internalLabels[index] == 2 || _internalLabels[index] == 1
                                ? Colors.yellow.shade800
                                : Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
