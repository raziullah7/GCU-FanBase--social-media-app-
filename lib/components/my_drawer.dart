import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app/components/my_list_tile.dart';

import '../pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  final Function()? onProfileTap;
  final Function()? onSignOutTap;

  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOutTap,
  });

  // sign out user
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header or title of the drawer
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),

              // list tile named 'Home'
              MyListTile(
                icon: Icons.home,
                text: "H O M E",
                // pop the drawer to go back to HomePage
                onTap: () => Navigator.pop(context),
              ),

              // list tile named 'Profile'
              MyListTile(
                icon: Icons.person_2_outlined,
                text: "P R O F I L E",
                onTap: () {
                  // pop the drawer
                  Navigator.of(context).pop();
                  // go to ProfilePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),

          // list tile named 'Logout'
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: MyListTile(
              icon: Icons.logout,
              text: "L O G O U T",
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
          ),
        ],
      ),
    );
  }
}
