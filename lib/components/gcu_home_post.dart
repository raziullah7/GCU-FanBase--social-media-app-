import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePost extends StatelessWidget {
  final String user;
  final String message;

  const HomePost({
    super.key,
    required this.user,
    required this.message,
  });

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
          // profile pic
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[500],
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 15),
          // username and email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user, style: TextStyle(color: Colors.grey[600])),
              Text(message),
            ],
          ),
        ],
      ),
    );
  }
}
