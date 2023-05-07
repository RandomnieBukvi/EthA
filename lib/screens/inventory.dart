import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/all_weapons.dart';
import 'package:lets_go/constans.dart';

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

List<String> bookItems = [];
List<String> notepadItems = [];

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => InventoryState();
}

double? notepadOffset = -300;
double? bookOffset = -300;

class InventoryState extends State<Inventory> {
  void notepadOnTap(int index) {
    setState(() {
      notepadItems.removeAt(index);
    });
  }

  void bookOnTap(int index) {
    if (!notepadItems.contains(bookItems[index])) {
      setState(() {
        notepadItems.add(bookItems[index]);
      });
    }
  }

  @override
  void initState() {
    bookItems = [];
    book.forEach((key, value) {
      bookItems.add(key);
    });
    notepadItems = [];
    notepad.forEach((key, value) {
      notepadItems.add(key);
    });

    Future.delayed(Duration.zero, () {
      setState(() {
        notepadOffset = 35;
        bookOffset = 0;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    notepadOffset = -300;
    bookOffset = -300;
    notepadSet();
    // TODO: implement dispose
    super.dispose();
  }

  void notepadSet() async {
    Map ntpd = Map();
    notepadItems.forEach((element) {
      ntpd.addAll({element: book[element]});
    });
    await inventoryDataRef.child('notepad').set(ntpd);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color(0xff6a4028),
      child: Column(
        children: [
          Flexible(
              flex: 1,
              child: Notepad(
                notepadOnTap: notepadOnTap,
              )),
          Flexible(
              flex: 1,
              child: Book(
                bookOnTap: bookOnTap,
              )),
        ],
      ),
    );
  }
}

class Notepad extends StatefulWidget {
  const Notepad({super.key, required this.notepadOnTap});
  final Function(int) notepadOnTap;
  @override
  State<Notepad> createState() => _NotepadState();
}

class _NotepadState extends State<Notepad> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          height: double.infinity,
          width: double.infinity,
        ),
        AnimatedPositioned(
          curve: Curves.ease,
          top: notepadOffset,
          duration: Duration(milliseconds: 150),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 2.2,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children: notepadItems
                      .map((key) => InventoryBox(
                            weaponKey: key,
                            onTap: widget.notepadOnTap,
                            index: notepadItems
                                .indexWhere((element) => element == key),
                            border: null,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class Book extends StatefulWidget {
  const Book({super.key, required this.bookOnTap});
  final Function(int) bookOnTap;
  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.centerEnd, children: [
      Container(
        height: double.infinity,
        width: double.infinity,
      ),
      AnimatedPositioned(
        curve: Curves.ease,
        duration: Duration(milliseconds: 150),
        right: bookOffset,
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2.8,
          width: MediaQuery.of(context).size.width * 6 / 7,
          child: Container(
            color: kPrimaryColor,
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 70, top: 10, bottom: 10),
              child: Container(
                color: Colors.white,
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: bookItems
                        .map((key) => InventoryBox(
                            weaponKey: key,
                            onTap: widget.bookOnTap,
                            index: bookItems
                                .indexWhere((element) => element == key),
                            border: notepadItems.contains(key)
                                ? Border.all(
                                    color: kPrimaryColor,
                                    width: 2,
                                    strokeAlign: BorderSide.strokeAlignOutside)
                                : null))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

//Клетки в блокноте и книжке
class InventoryBox extends StatefulWidget {
  InventoryBox(
      {super.key,
      required this.weaponKey,
      required this.onTap,
      required this.index,
      required this.border});
  final String weaponKey;
  final Function(int) onTap;
  final int index;
  final Border? border;
  @override
  State<InventoryBox> createState() => _InventoryBoxState();
}

class _InventoryBoxState extends State<InventoryBox> {
  tap() {
    widget.onTap(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: SizedBox(
        height: 50,
        width: 50,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: widget.border),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(weapons[widget.weaponKey]!.imagePath,
                  style: TextStyle(fontSize: 30)),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
