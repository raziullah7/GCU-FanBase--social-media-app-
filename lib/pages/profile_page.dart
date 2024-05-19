import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app/components/my_text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // getting user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // getting the 'Users' collection
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  // edit field for username
  Future<void> editField(String field) async {
    String newValue = "";

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) => newValue = value,
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),

          // save button
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // update the FireStore
    if (newValue.trim().isNotEmpty) {
      // only update if the newValue is not an empty string
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 69),
          child:
              Text("Profile Page"),
        ),
        // backgroundColor: Colors.grey[900],
        // iconTheme: IconThemeData(color: Colors.grey[300]),
      ),
      body: StreamBuilder(
        // listen to collection named 'Users' with document name equal
        // to the currentUser's name stream
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          // if the data snapshot exists, display ListView
          if (snapshot.hasData) {
            // store the user's data as a map for convenience
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                // margin
                const SizedBox(height: 50),
                // profile pic
                const Icon(Icons.person, size: 72),
                const SizedBox(height: 10),

                // user email
                Text(currentUser.email!, textAlign: TextAlign.center),
                const SizedBox(height: 50),

                // user details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My details",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 10),

                // username
                MyTextBox(
                  text: userData["username"],
                  section: "username",
                  onPressed: () => editField("username"),
                ),
                const SizedBox(height: 10),

                // bio
                MyTextBox(
                  text: userData["bio"],
                  section: "bio",
                  onPressed: () => editField("bio"),
                ),
                const SizedBox(height: 20),

                // // user posts
                // Padding(
                //   padding: const EdgeInsets.only(left: 25.0),
                //   child: Text(
                //     "My Posts",
                //     style: TextStyle(color: Colors.grey[600]),
                //   ),
                // ),
                // const SizedBox(height: 10),
              ],
            );
            // else if there was an error, display an error
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error ${snapshot.error}"),
            );
          }
          // display a loading circle either way
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
