import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String section;
  final void Function()? onPressed;

  const MyTextBox({
    super.key,
    required this.text,
    required this.section,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // generic heading
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  section,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),

              //edit button
              IconButton(
                onPressed: onPressed,
                color: Colors.grey[500],
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          // data from FireBase
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
