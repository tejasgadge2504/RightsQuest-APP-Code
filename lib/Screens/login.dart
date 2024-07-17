import 'package:flutter/material.dart';
import 'package:moralmentor/Screens/quiz.dart';
import 'package:moralmentor/src/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/LoginAvtar.png',width: 200,),
              Text('Login to Start your Journey to become a Rights Questee',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
              SizedBox(height: 8,),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle the submit button press
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  print('Email: $email');
                  print('Password: $password');
                  // Perform login action here
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // Handle the signup button press
                  print('Navigating to signup page');
                  // Add your signup navigation logic here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                    ),
                    Text(" SignUp",
                        style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 18),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
