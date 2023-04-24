import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_go/constans.dart';
import 'package:lets_go/screens/inventory.dart';
import 'package:lets_go/screens/map.dart';
import 'package:lets_go/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/Auth.dart';
import 'package:lets_go/screens/weapons.dart';
import 'package:lets_go/sidemenu.dart';

class Fabs extends StatelessWidget {
  Fabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FabTabs(selectedIndex: 0);
          } else {
            return Auth();
          }
        });
  }
}

class FabTabs extends StatefulWidget {
  int selectedIndex = 0;

  FabTabs({required this.selectedIndex});

  @override
  State<FabTabs> createState() => _FabTabsState();
}

class _FabTabsState extends State<FabTabs> {
  int currentIndex = 0;

  @override
  void initState() {
    currentIndex = widget.selectedIndex;
    // TODO: implement initState
    super.initState();
  }

  final List<Widget> pages = [GameMap(), Weapons(), Inventory()];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    Widget currentScreen = pages[currentIndex];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      drawer: SideMenu(),
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: kPrimaryColor,
          indicatorColor: Colors.white70,
          ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.map_outlined,color: Color.fromARGB(230, 255, 255, 255),), selectedIcon: Icon(Icons.map_outlined, color: Colors.black,),label: 'Map'),
            NavigationDestination(
                icon: Icon(Icons.calculate,color: Color.fromARGB(230, 255, 255, 255),), selectedIcon: Icon(Icons.calculate,color: Colors.black,), label: 'Weapons'),
            NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined,color: Color.fromARGB(230, 255, 255, 255),), selectedIcon: Icon(Icons.inventory_2_outlined,color: Colors.black,), label: 'Inventory'),
          ],
        ),
      ),
    );
  }
}
