import 'package:flutter/material.dart';
import 'package:moralmentor/src/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "MORALMENTOR",
              style: TextStyle(color: AppBarTextColor.shade600,fontWeight: FontWeight.bold,fontSize: 25),
            ),
            SizedBox(width: size.width*0.3,),
            InkWell(onTap: (){
              // Direct To Profile Page on Tap
            },
                child: Icon(Icons.person,color: AppBarTextColor,)),
          ],
        ),
        backgroundColor: AppBarColor,
      ),
    );
  }
}
