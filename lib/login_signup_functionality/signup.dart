import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapplication/login_signup_functionality/log_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/sharedPref.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  Future<void> signUpWithEmail() async {
    try {
      final String email = _emailController.text.toString();
      final String password = _passwordController.text.toString();
      final FirebaseAuth _auth = FirebaseAuth.instance;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter email and password.'),
          backgroundColor: Colors.red,
        ));
        return;
      }

      final UserCredential userCredential = (await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password))
        ..user;

      final User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'email': email,
          'password': password,
          'uid': userCredential.user!.uid
        });
        saveUserData(email, password);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return LogIn();
          },
        ));
      }
      // Handle successful sign-up
    } catch (e) {
      print('Sign-up error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign-up failed. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  goToSignInPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ));
  }
  Future<void> saveUserData(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferencesManager.instance?.isLoggedIn = true;
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0,right: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Text(
                  'A complete app for prepare ISSB Bangladesh',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.0,
                      letterSpacing: 1.4,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.019,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true, // Add a background color
                    fillColor: Colors.grey[150], // Set the background color
                    border: OutlineInputBorder(
                      // Add border radius
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.020,
                ),
                ElevatedButton(
                  onPressed:  signUpWithEmail,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text('Sign Up')),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    TextButton(onPressed: goToSignInPage, child: Text('Sign In')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
