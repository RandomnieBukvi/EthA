import 'package:flutter/material.dart';
import 'package:lets_go/constans.dart';
import 'package:lets_go/all_weapons.dart';

double weaponActionsPositon = 0;
String weaponTxt = weapons[0].name;
String weaponDesc = weapons[0].description;

class Weapons extends StatefulWidget {
  Weapons({super.key});

  @override
  State<Weapons> createState() => _WeaponsState();
}

class _WeaponsState extends State<Weapons> {
  var scrollCTRL = PageController(viewportFraction: 0.5);

  @override
  void initState() {
    weaponTxt = weapons[0].name;
    weaponDesc = weapons[0].description;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 2,
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
                          /*setState(() async {
                            weaponActionsPositon = -400;
                            await Future.delayed(Duration(milliseconds: 150)).then((value){
                              weaponTxt = weapons[value].name;
                            weaponDesc = weapons[value].description;
                            });
                            weaponActionsPositon = 0;
                          });*/
                          setState(() {
                            weaponActionsPositon = -400;
                          });
                          await Future.delayed(Duration(milliseconds: 150))
                              .then((_) {
                            setState(() {
                              weaponTxt = weapons[value].name;
                              weaponDesc = weapons[value].description;
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
        Flexible(flex: 3, child: WeaponActions()),
      ],
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
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Image.asset(weapons[index].imagePath),
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
              decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    weaponTxt,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Divider(
                      thickness: 1,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(weaponDesc, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
