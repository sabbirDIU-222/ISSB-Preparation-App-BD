import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapplication/views/chatScreen.dart';
import 'package:quizapplication/home_screen_preli/home.dart';

class TrainerHome extends StatefulWidget {
  const TrainerHome({Key? key}) : super(key: key);

  @override
  State<TrainerHome> createState() => _TrainerHomeState();
}

class _TrainerHomeState extends State<TrainerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Welcome Trainer'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: SignOutFunction, icon: Icon(Icons.logout_outlined)),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 9.0, left: 5.0, right: 5.0, bottom: 8.0),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.height / 1,
            child: Card(
              color: Color(0xFFa5d6a7),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('images/logo.png'),
                      radius: 50,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Discussion is open',
                              textAlign: TextAlign.center,
                              style: TextStyle(

                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserListScreen(),
                                )),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1c305c),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),

                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'Chat with Candidates',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // sign out functuib
  void SignOutFunction() async {
    try {
      await FirebaseAuth.instance.signOut();
      //removeTrainerEmail();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Home();
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

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Chats'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<QueryDocumentSnapshot> documents =
                      snapshot.data!.docs as List<QueryDocumentSnapshot>;
                  final totalUsers = documents.length;

                  return Container(
                    width: 120,
                    child: Center(
                      child: Text(
                        'active Users #$totalUsers',
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return CircularProgressIndicator();
        }

        final List<QueryDocumentSnapshot> documents =
            snapshot.data!.docs as List<QueryDocumentSnapshot>;

        // Filter out the current user's email
        final currentUserEmail = _auth.currentUser?.email;
        final filteredDocuments = documents.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          final email = data?['email'] as String?;
          return email != null && email != currentUserEmail;
        }).toList();

        return ListView.builder(
          itemCount: filteredDocuments.length,
          itemBuilder: (context, index) {
            final doc = filteredDocuments[index];
            return _buildUserListItem(context, doc, index);
          },
        );
      },
    );
  }

  Color _getAvatarColor(int index) {
    List<Color> avatarColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];

    return avatarColors[index % avatarColors.length];
  }

  Widget _buildUserListItem(
      BuildContext context, QueryDocumentSnapshot document, int index) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data != null) {
      final userEmail = data['email'] as String?;
      final userId = data['uid'] as String?;
      final firstNameLetter = userEmail![0].toUpperCase();
      final firstLetter = userEmail!.split('@').first.toUpperCase();
      final avatarColor = _getAvatarColor(index);

      if (userEmail != null && userEmail.isNotEmpty && userId != null) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 5.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: avatarColor,
              child: Text(
                firstNameLetter,
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w900),
              ),
            ),
            title: Text(firstLetter),
            onTap: () {
              _navigateToChatPage(context, userEmail, userId);
            },
          ),
        );
      }
    }

    return Container();
  }

  void _navigateToChatPage(
      BuildContext context, String receiverUserEmail, String receiverUserId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverUserEmail: receiverUserEmail,
          receiverUserId: receiverUserId,
        ),
      ),
    );
  }
}
