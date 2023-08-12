import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:quizapplication/login_signup_functionality/signup.dart';
import 'package:quizapplication/admin_screen_ui/adminHome.dart';
import 'package:quizapplication/trainer_screen_ui/trainerHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import '../services/sharedPref.dart';

class LogIn extends StatefulWidget {
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //checkUserLoggedIn();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      showSimpleNotification(
          Text(connected ? 'Internet CONNECTED' : 'No INTERNET'),
          background: Colors.teal);
    });
  }

  void checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: Text(
                'TACTICAL ROAD TO DEFENCE',
                style: TextStyle(
                  letterSpacing: 1.1,
                    fontFamily: 'Sirin',
                    fontSize: 25.0,
                    color: Colors.green[900],
                    fontWeight: FontWeight.w600),
              )),
              Container(
                  height: MediaQuery.of(context).size.height * 0.19,
                  child: Image.asset(
                    'images/usersimage.png',
                    fit: BoxFit.cover,
                  )),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Inter Service Selection Board Exam Preparation',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12.0,
                    letterSpacing: 1.4,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              Padding(
                padding: const EdgeInsets.all(19.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true, // Add a background color
                        fillColor: Colors.grey[150], // Set the background color
                        border: OutlineInputBorder(
                            // Add border radius
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.015,
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true, // Add a background color
                        fillColor: Colors.grey[150], // Set the background color
                        border: OutlineInputBorder(
                            // Add border radius
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    ElevatedButton(
                      onPressed: signInWithEmail,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Log in with Email',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Center(
                  child: Divider(
                color: Colors.green,
                endIndent: 100,
                indent: 100,
              )),
              //Text('-------or-------',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w300),),

              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    signinWithGoogle(context);
                  },
                ),
              ),
              SizedBox(height: 5.0),

              // Sign up section
              TextButton(
                onPressed: signUp,
                child: Text(
                  'don\'t have an account? Sign Up',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0,fontFamily: 'Sirin',letterSpacing: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUp(),
      ),
    );
  }
  // log in with email and pass

  Future<void> signInWithEmail() async {
    try {
      final String email = _emailController.text;
      final String password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        showSimpleNotification(
          Text('Please enter email and password.'),
          background: Colors.red,
        );
        return;
      }

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'password': password,
          'uid': userCredential.user!.uid
        });
        saveUserData(email, password);

        if (email == 'trainer1@gmail.com' && password == 'trainer1234') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TrainerHome()),
          );
          _emailController.clear(); // Clear email text field
          _passwordController.clear();
          return;
        }
        if (email == 'admin@gmail.com' && password == 'admin1234') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
          _emailController.clear(); // Clear email text field
          _passwordController.clear();
          return;
        }
        Navigator.pushReplacementNamed(context, '/home');
        _emailController.clear(); // Clear email text field
        _passwordController.clear();
      }

      // Handle successful login
    } catch (e) {
      print('Login error: $e');
      showSimpleNotification(
        Text('Login failed. Please try again.'),
        background: Colors.red,
      );
    }
  }
}

Future<void> saveUserData(String email, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPreferencesManager.instance?.isLoggedIn = true;
  await prefs.setString('email', email);
  await prefs.setString('password', password);
}
