import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
            return FabTabs();
          } else {
            return Auth();
          }
        });
  }
}

class FabTabs extends StatefulWidget {
  const FabTabs({super.key});

  @override
  State<FabTabs> createState() => _FabTabsState();
}

class _FabTabsState extends State<FabTabs> {
  int currentIndex = 0;
  int experience = 0;
  int cash = 0;
  DatabaseReference userDataRef = FirebaseDatabase.instance.ref('usersData/${FirebaseAuth.instance.currentUser!.displayName}');
  late Stream<DatabaseEvent> userDataChange = userDataRef.onValue;
  @override
  void initState() {
    currentIndex = 0;
    userDataChange.listen((event) { 
      var data = event.snapshot;
      setState(() {
        experience = int.parse(data.child('experience').value.toString());
        cash = int.parse(data.child('cash').value.toString());
      });
    });
    // TODO: implement initState
    super.initState();
  }
  
  final List<Widget> pages = [GameMap(), Weapons(), Inventory()];

  @override
  Widget build(BuildContext context) {
    Widget currentScreen = pages[currentIndex];
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Row(children: [
        Icon(Icons.attach_money_sharp),
        Text(cash.toString()),
        SizedBox(width: 20,),
        Icon(Icons.star),
        Text(experience.toString()),
      ],)),
      drawer: SideMenu(),
      body: currentScreen,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith(
              (states) => TextStyle(color: Colors.white70)),
          backgroundColor: kPrimaryColor,
          indicatorColor: Color.fromRGBO(255, 255, 255, 0.702),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
                icon: Icon(
                  Icons.map_sharp,
                  color: Color.fromARGB(230, 255, 255, 255),
                ),
                selectedIcon: Icon(
                  Icons.map_sharp,
                  color: Colors.black,
                ),
                label: 'Map'),
            NavigationDestination(
                icon: Icon(
                  Icons.calculate_sharp,
                  color: Color.fromARGB(230, 255, 255, 255),
                ),
                selectedIcon: Icon(
                  Icons.calculate_sharp,
                  color: Colors.black,
                ),
                label: 'Weapons'),
            NavigationDestination(
                icon: Icon(
                  Icons.calendar_view_month_sharp,
                  color: Color.fromARGB(230, 255, 255, 255),
                ),
                selectedIcon: Icon(
                  Icons.calendar_view_month_sharp,
                  color: Colors.black,
                ),
                label: 'Inventory'),
          ],
        ),
      ),
    );
  }
}
