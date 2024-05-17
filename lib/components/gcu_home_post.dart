import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app/components/like_button.dart';

class HomePost extends StatefulWidget {
  final String user;
  final String message;
  final String postId;
  final List<String> likes;

  const HomePost({
    super.key,
    required this.user,
    required this.message,
    required this.postId,
    required this.likes,
  });

  @override
  State<HomePost> createState() => _HomePostState();
}

class _HomePostState extends State<HomePost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Row(
        children: [
          // // profile pic
          // Container(
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.grey[500],
          //   ),
          //   padding: const EdgeInsets.all(8),
          //   child: const Icon(Icons.person, color: Colors.white),
          // ),

          Column(
            children: [
              // like button and count
              LikeButton(isLiked: isLiked, onTap: toggleLike),
              // margin
              const SizedBox(width: 5),
              // count of likes
              Text(
                widget.likes.length.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(width: 15),
          // user email and message
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.grey[600])),
              Text(widget.message),
            ],
          ),
        ],
      ),
    );
  }
}
