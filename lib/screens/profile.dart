import 'package:flutter/material.dart';
import 'package:lets_go/constans.dart';
import 'package:lets_go/sidemenu.dart';
import 'package:lets_go/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), centerTitle: true,elevation: 0,),
      body: Container(
        color: kOtherColor,
        child: Column(
          children: [
            Material(
              elevation: 4,
              borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)
                  ),
              child: Container(
                padding: EdgeInsets.all(20),
                /*(
                  top: MediaQuery.of(context).padding.top + 20,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),*/
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)
                  ),
                ),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.cyan,
                      border: Border.all(
                        width: 3,
                        color: kSecondaryColor
                      ),
                      ),
                    
                    child: Image.asset('assets/images/MAIN CHARECTER1.png'),
                  ),
                  kWidthSizedBox,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: user.displayName == null ? CircularProgressIndicator(color: kTextBlackColor,) : Text(
                              user.displayName!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                            ),
                          ),
                        Text('Rating:1987 | Leaderboard:4',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )
                ],
              ),
              ),
            ),
            sizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(
                    title: 'Number', value: '2020-ASDF-2021'),
                ProfileDetailRow(title: 'Rating', value: '2020-2021'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(title: 'Grade', value: 'X-II'),
                ProfileDetailRow(title: 'Questions', value: '000126'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(
                    title: 'Date of Birth', value: '1 Aug, 2020'),
                ProfileDetailRow(title: 'Leaderboard rating', value: '3 May 1998'),
              ],
            ),
            sizedBox,
            ProfileDetailColumn(
              title: 'Email',
              value: user.email!,
            ),
            ProfileDetailColumn(
              title: 'School',
              value: 'John Mirza',
            ),
            ProfileDetailColumn(
              title: 'IDK',
              value: 'Angelica Mirza',
            ),
            ProfileDetailColumn(
              title: 'Phone Number',
              value: '+923066666666',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({Key? key, required this.title, required this.value})
      : super(key: key);
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width/2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: kTextBlackColor,
                  fontSize: 15,
                ),
              ),
              kHalfSizedBox,
              Text(value, style: Theme.of(context).textTheme.caption),
              kHalfSizedBox,
              SizedBox(
                width: MediaQuery.of(context).size.width/3,
                child: Divider(
                  thickness: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileDetailColumn extends StatelessWidget {
  const ProfileDetailColumn(
      {Key? key, required this.title, required this.value})
      : super(key: key);
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: kTextBlackColor,
                  fontSize: 15,
                ),
              ),
              kHalfSizedBox,
              Text(value, style: Theme.of(context).textTheme.caption),
              kHalfSizedBox,
              SizedBox(
                width: MediaQuery.of(context).size.width/1.2,
                child: Divider(
                  thickness: 1.0,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}