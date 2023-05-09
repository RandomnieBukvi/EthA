import 'package:flutter/material.dart';
import 'package:lets_go/screens/game.dart';

class GameMap extends StatelessWidget {
  const GameMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => Game())));
      }, child: Text('press')),
    );
  }
}
