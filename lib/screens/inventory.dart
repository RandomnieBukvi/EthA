import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/all_weapons.dart';

Map inventory = Map();
DatabaseReference inventoryDataRef = FirebaseDatabase.instance.ref(
    'usersData/${FirebaseAuth.instance.currentUser!.displayName}/inventory');

late StreamSubscription<DatabaseEvent> inventoryChange;
void initInventory() async {
  inventoryChange = inventoryDataRef.onValue.listen((event) async {
    inventory = {};
    event.snapshot.children.forEach((element) {
      inventory.addAll({element.key: element.value});
    });
  });
}
List<Widget> items = [];
class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => InventoryState();
}

class InventoryState extends State<Inventory> {
  @override
  void initState() {
    items.clear();
    inventory.forEach((key, value) {
      items.add(Text(weapons[int.parse(key)].name));
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //inventoryChange.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: items,
      ),
    );
  }
}
