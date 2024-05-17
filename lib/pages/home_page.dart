import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app/components/gcu_home_post.dart';
import 'package:the_final_app/components/my_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controller
  TextEditingController postTextController = TextEditingController();

  // getting the current user state snapshot from the Firebase
  final currentUser = FirebaseAuth.instance.currentUser;

  // sign out user
  void signOut() async {
    FirebaseAuth.instance.signOut();
  }

  // function that posts the message onto the GCU home page
  // POST the message to the FireStore
  void postMessage() {
    // if the text field is not empty
    if (postTextController.text.isNotEmpty) {
      // store the data in the FireStore in Map format
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": currentUser?.email,
        "Message": postTextController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }
    // clear the controller after pressing the upload button
    setState(() {
      postTextController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(
          child: Text(
            "GCU FanBase",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout, color: Colors.white, weight: 700),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // GCU home page (GET posts from the FireStore)
            Expanded(
              child: StreamBuilder(
                // listen to the stream of snapshots from "User Posts" collection
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp")
                    .snapshots(),
                builder: (context, snapshot) {
                  // if the data exists, get it
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        // make a post from the snapshot and return it as HomePost
                        final post = snapshot.data!.docs[index];
                        return HomePost(
                          user: post['UserEmail'],
                          message: post['Message'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                        );
                      },
                    );
                    // else display an error
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  // show a loading circle
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // post messages via text field
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: postTextController,
                      hintText: "Say something . . .",
                      obscureText: false,
                    ),
                  ),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 10, right: 0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: postMessage,
                      icon: const Icon(Icons.upload),
                    ),
                  ),
                ],
              ),
            ),

            // logged in as what user
            Text(
              "Logged in as: ${currentUser?.email}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
