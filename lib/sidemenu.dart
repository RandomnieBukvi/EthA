import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_go/screens/FabTabs.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/screens/leader_board.dart';
import 'package:lets_go/screens/profile.dart';
import 'package:lets_go/screens/settings.dart';
import 'package:lets_go/shared_prefs.dart';

import 'constans.dart';

class SideMenu extends StatefulWidget {
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  User user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 150,
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyProfileScreen())),
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  right: 20,
                  left: 20,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                  ),
                  color: kPrimaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        border: Border.all(width: 3, color: kSecondaryColor),
                      ),
                      child: Image.asset('assets/images/MAIN CHARECTER1.png'),
                    ),
                    kWidthSizedBox,
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: user.displayName == null
                            ? CircularProgressIndicator(
                                color: kTextBlackColor,
                              )
                            : Text(
                                user.displayName!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                    kWidthSizedBox,
                    Icon(Icons.arrow_forward_ios,color: Colors.white,)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GameSettings()))),
                ListTile(
                    leading: Icon(Icons.leaderboard_outlined),
                    title: Text("Leaderboard"),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LeaderBoard()))),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Log out"),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
