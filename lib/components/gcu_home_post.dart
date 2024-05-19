import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app/components/comment_button.dart';
import 'package:the_final_app/components/comment.dart';
import 'package:the_final_app/components/like_button.dart';

import '../helper/helper_methods.dart';
import 'comment.dart';

class HomePost extends StatefulWidget {
  final String user;
  final String message;
  final String postId;
  final String time;
  final List<String> likes;

  const HomePost({
    super.key,
    required this.user,
    required this.message,
    required this.postId,
    required this.time,
    required this.likes,
  });

  @override
  State<HomePost> createState() => _HomePostState();
}

class _HomePostState extends State<HomePost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  // text controller for add comment text field
  final TextEditingController _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // if the current user's email is contained in the list of likes
    // then the button should be Icons.favorite, else Icons.favorite_border
    // sets isLiked to true or false for red heart or grey heart respectively
    isLiked = widget.likes.contains(currentUser.email);
  }

  // void displayMessage(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(title: Text(message)),
  //   );
  // }

  // toggle between true and false for isLiked boolean
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // access document to add to the likes list
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      // if post is liked, add user's email to the likes list
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      // if post is not liked, remove user's email to the likes list
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  // add a comment
  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now(),
    });
  }

  // show a dialog box for adding a new comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          decoration: const InputDecoration(hintText: "Write a comment..."),
          controller: _commentTextController,
        ),
        actions: [
          // save post button
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Post"),
          ),

          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // USER EMAIL + USER POST
          const SizedBox(width: 15),
          // user email and message
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              Row(
                children: [
                  Text(widget.user, style: TextStyle(color: Colors.grey[500])),
                  Text(" • ", style: TextStyle(color: Colors.grey[500])),
                  Text(widget.time, style: TextStyle(color: Colors.grey[500])),
                ],
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),

          // LIKES + COUNT OF LIKES + COMMENTS + COUNT OF COMMENTS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  // like button and count
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  // count of likes
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  // comment button and count
                  CommentButton(onTap: showCommentDialog),
                  // count of comments
                  const Text(
                    "0",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 5),

          // DISPLAYING COMMENTS
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              // if there is no data
              if (!snapshot.hasData) {
                // show loading circle
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  // get the comments
                  final commentData = doc.data() as Map<String, dynamic>;

                  // return the comments
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"],
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
