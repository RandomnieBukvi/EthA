import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/screens/loading_screen.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Leaderboard"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseDatabase.instance
              .ref('usersData')
              .orderByChild('cash')
              .limitToLast(10)
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            } else {
              Map leaderBoard = Map();
              snapshot.data!.snapshot.children.forEach((element) {
                leaderBoard.addAll({element.key: element.value});
              });
              List<Widget> leaderBoardList = [];
              leaderBoard.forEach((key, value) {
                leaderBoardList.add(ListTile(
                  title: Text(key),
                  subtitle: Text(value['cash'].toString()),
                ));
              });
              leaderBoardList = leaderBoardList.reversed.toList();
              return ListView(
                children: leaderBoardList,
              );
            }
          }),
    );
  }
}
