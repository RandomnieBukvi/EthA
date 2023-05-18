import 'package:flutter/material.dart';
import 'package:lets_go/constans.dart';
import 'package:lets_go/screens/game.dart';

class GameMap extends StatelessWidget {
  const GameMap({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      constrained: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 2,
        width: MediaQuery.of(context).size.height * 2,
        decoration: BoxDecoration(image: DecorationImage(
                  filterQuality: FilterQuality.none,
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/game map.png'),
                )),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
              left: MediaQuery.of(context).size.height * 1.3,
              top: MediaQuery.of(context).size.height / 1.4,
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => Game())));
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 3,
                    ),
                    shape: BoxShape.circle
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
