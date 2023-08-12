import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapplication/login_signup_functionality/log_in.dart';
import 'drawerHeaderSection.dart';

class SideDrawer extends StatefulWidget {
  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return Drawer(
        // width: MediaQuery.of(context).size.width * 0.7,
        child: Material(
          color: Color(0xFF556B2F),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              DrawerHeaderSection(user: user),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Divider(
                thickness: 0.5,
                indent: 10,
                endIndent: 10,
                color: Colors.white,
              ),
              listItem(
                  label: 'IQ', iconData: Icons.quiz_sharp, context: context),
              listItem(label: 'PPDT', iconData: Icons.image, context: context),
              listItem(
                  label: 'WAT',
                  iconData: Icons.sort_by_alpha,
                  context: context),
              listItem(
                  label: 'Incomplete Story',
                  iconData: Icons.history_outlined,
                  context: context),
              listItem(
                  label: 'Plannig Exersize',
                  iconData: Icons.change_history,
                  context: context),

              listItem(
                  label: 'Open Discussion',
                  iconData: Icons.self_improvement,
                  context: context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.11,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF4B5320),
                      borderRadius: BorderRadius.circular(10)),
                  child: listItem(
                      label: 'Sign out',
                      iconData: Icons.logout,
                      context: context),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Drawer(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/logIn');
          },
          child: Material(
            color: Color.fromRGBO(69, 75, 27, 1),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.14,
                  decoration: BoxDecoration(
                      color: Color(0xFF556B2F),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                    child: Text(
                      'LogIn',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Sirin',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Colors.grey,
                ),
                Text(
                  'you are not a user. please log In\nTHE ISSB PRACTICE',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                      letterSpacing: 1.5,
                      wordSpacing: 2),
                  textAlign: TextAlign.justify,
                )
              ],
            )),
          ),
        ),
      );
    }
  }

  Widget listItem(
      {required String label,
      required IconData iconData,
      required BuildContext context}) {
    final color = Colors.white;
    final hovercolor = Colors.black54;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: color,
        ),
      ),
      leading: Icon(
        iconData,
        color: color,
      ),
      hoverColor: hovercolor,
      onTap: () {
        switch (label) {
          case 'IQ':
            Navigator.pushNamed(context, '/iq');
            break;
          case 'PPDT':
            Navigator.pushNamed(context, '/ppdt');
            break;
          case 'Plannig Exersize':
            Navigator.pushNamed(context, '/storywriting');
            break;
          case 'WAT':
            Navigator.pushNamed(context, '/wat');
            break;
          case 'Incomplete Story':
            Navigator.pushNamed(context, '/incompletestory');
            break;
          case 'Open Discussion':
            Navigator.pushNamed(context, '/trainerprofile');
            break;
          case 'Sign out':
            SignOutFunction();
            break;
        }
      },
    );
  }

  void SignOutFunction() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return LogIn();
        },
      ));
    } catch (e) {
      print('Sign-out error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign-out failed. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
