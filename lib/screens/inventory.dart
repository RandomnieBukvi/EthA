import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/all_weapons.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  DatabaseReference InventoryDataRef = FirebaseDatabase.instance.ref(
      'usersData/${FirebaseAuth.instance.currentUser!.displayName}/inventory');
  late Stream<DatabaseEvent> InventoryDataChange = InventoryDataRef.onValue;
  Map inventory = Map();
  @override
  void initState() {
    InventoryDataChange.listen((event) {
      setState(() {
        event.snapshot.children.forEach((element) {
          inventory.addAll({element.key: element.value});
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    inventory.forEach((key, value) {
      items.add(
        Text(
          weapons[int.parse(key)].name
        )
      );
    });
    return Center(
      child: Column(
        children: items,
      ),
    );
  }
}
