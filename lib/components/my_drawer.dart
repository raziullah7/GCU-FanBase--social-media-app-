import 'package:flutter/material.dart';
import 'package:the_final_app/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOutTap;

  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
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
            onTap: () => onProfileTap,
          ),

          // list tile named 'Logout'
          MyListTile(
            icon: Icons.logout,
            text: "L O G O U T",
            onTap: () => onSignOutTap,
          ),
        ],
      ),
    );
  }
}
