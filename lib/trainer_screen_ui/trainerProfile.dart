import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../views/chatScreen.dart';

class TrainerProfile extends StatefulWidget {
  const TrainerProfile({Key? key}) : super(key: key);

  @override
  State<TrainerProfile> createState() => _TrainerProfileState();
}

class _TrainerProfileState extends State<TrainerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Tactical Road To Defense'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Card(
              /*color: Color.fromRGBO(69, 75, 27, 1),*/
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('images/usersimage.png'),
                      radius: 50,
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Open Discussion',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontFamily: 'Sirin',
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                //backgroundColor: Color(0xFF556B2F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserListScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  'Chat',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
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
