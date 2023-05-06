import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/all_weapons.dart';

Map book = Map();
Map notepad = Map();
DatabaseReference inventoryDataRef = FirebaseDatabase.instance.ref(
    'usersData/${FirebaseAuth.instance.currentUser!.displayName}/inventory');

late StreamSubscription<DatabaseEvent> inventoryChange;
void initInventory() async {
  inventoryChange = inventoryDataRef.onValue.listen((event) {
    book = {};
    notepad = {};
    event.snapshot.child('book').children.forEach((element) {
      book.addAll({element.key: element.value});
    });
    Map bufer = Map();
    weapons.keys.forEach((wKey) {
      if (book[wKey] != null) {
        bufer.addAll({wKey: book[wKey]});
      }
    });
    book = bufer;

    event.snapshot.child('notepad').children.forEach((element) {
      notepad.addAll({element.key: element.value});
    });
    bufer = {};
    weapons.keys.forEach((wKey) {
      if (notepad[wKey] != null) {
        bufer.addAll({wKey: notepad[wKey]});
      }
    });
    notepad = bufer;
  });
}

List<Widget> bookItems = [];
List<Widget> notepadItems = [];

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => InventoryState();
}

class InventoryState extends State<Inventory> {
  @override
  void initState() {
    bookItems = [];
    book.forEach((key, value) {
      bookItems.add(Text(
        weapons[key]!.imagePath,
        style: TextStyle(fontSize: 50),
      ));
    });
    notepadItems = [];
    notepad.forEach((key, value) {
      notepadItems.add(Text(
        weapons[key]!.imagePath,
        style: TextStyle(fontSize: 50),
      ));
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: bookItems,
      ),
    );
  }
}
