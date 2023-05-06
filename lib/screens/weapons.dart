import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/constans.dart';
import 'package:lets_go/all_weapons.dart';
import 'package:lets_go/screens/inventory.dart';

double weaponActionsPositon = 0;
String weaponTxt = weapons.keys.elementAt(0);
String weaponDesc = weapons.values.elementAt(0).description;
int itemIndex = 0;
DatabaseReference userDataRef = FirebaseDatabase.instance
    .ref('usersData/${FirebaseAuth.instance.currentUser!.displayName}');
bool isWeaponNotAquired = false;

class Weapons extends StatefulWidget {
  Weapons({super.key});

  @override
  State<Weapons> createState() => _WeaponsState();
}

class _WeaponsState extends State<Weapons> {
  var scrollCTRL = PageController(viewportFraction: 0.5);
  @override
  void initState() {
    weaponTxt = weapons.keys.elementAt(0);
    weaponDesc = weapons.values.elementAt(0).description;
    itemIndex = 0;
    isWeaponNotAquired = !book.containsKey(weapons.keys.elementAt(itemIndex));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.grey,
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                filterQuality: FilterQuality.none,
                fit: BoxFit.contain,
                image: AssetImage('assets/images/standImage.png'),
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 2,
                        child: PageView.builder(
                            onPageChanged: (value) async {
                              itemIndex = value;
                              setState(() {
                                weaponActionsPositon =
                                    -MediaQuery.of(context).size.height;
                              });
                              await Future.delayed(Duration(milliseconds: 150))
                                  .then((_) {
                                setState(() {
                                  weaponTxt = weapons.keys.elementAt(value);
                                  weaponDesc = weapons.values
                                      .elementAt(value)
                                      .description;
                                  isWeaponNotAquired = !book.containsKey(
                                      weapons.keys.elementAt(itemIndex));
                                });
                              });
                              setState(() {
                                weaponActionsPositon = 0;
                              });
                            },
                            controller: scrollCTRL,
                            itemCount: weapons.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => WeaponBox(index)),
                      ),
                      Positioned(
                        //bottom: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 50,
                              child: IconButton(
                                onPressed: () {
                                  scrollCTRL.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.decelerate);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new_sharp,
                                  size: 50,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              width: 50,
                              child: IconButton(
                                onPressed: () {
                                  scrollCTRL.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.decelerate);
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(flex: 4, child: WeaponActions()),
        ],
      ),
    );
  }
}

class WeaponBox extends StatelessWidget {
  const WeaponBox(this.index, {super.key});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SizedBox(
        height: 300,
        width: 300,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: GridPaper(
              divisions: 1,
              subdivisions: 1,
              interval: 20,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(weapons.values.elementAt(index).imagePath,
                      style: TextStyle(fontSize: 60)),
                ),
              )),
        ),
      ),
    );
  }
}

class WeaponActions extends StatefulWidget {
  const WeaponActions({super.key});

  @override
  State<WeaponActions> createState() => _WeaponActionsState();
}

class _WeaponActionsState extends State<WeaponActions> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 150),
          bottom: weaponActionsPositon,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              alignment: Alignment.topCenter,
              child: GridPaper(
                interval: 20,
                divisions: 1,
                subdivisions: 1,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            weaponTxt,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(weaponDesc, style: TextStyle(fontSize: 20)),
                          Divider(
                            thickness: 2,
                            color: kPrimaryColor,
                          ),
                          isWeaponNotAquired
                              ? ElevatedButton(
                                  onPressed: () async {
                                    var event = await userDataRef.get();
                                    if (int.parse(event
                                            .child('cash')
                                            .value
                                            .toString()) <
                                        weapons.values
                                            .elementAt(itemIndex)
                                            .cost) {
                                      print("LOL YOU GOT NO MONEY");
                                    } else {
                                      userDataRef
                                          .child(
                                              'inventory/book/${weapons.keys.elementAt(itemIndex)}')
                                          .set({'level': 1});
                                      userDataRef.child('cash').set(int.parse(
                                              event
                                                  .child('cash')
                                                  .value
                                                  .toString()) -
                                          weapons.values
                                              .elementAt(itemIndex)
                                              .cost);
                                      setState(() {
                                        isWeaponNotAquired = false;
                                      });
                                    }
                                  },
                                  child: Text(weapons.values
                                      .elementAt(itemIndex)
                                      .cost
                                      .toString()))
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
