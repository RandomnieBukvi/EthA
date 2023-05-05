import 'package:flutter/material.dart';

List<Weapon> weapons = [
  Weapon(
      name: "Plus",
      description: "Becomes a shuriken. distance weapon",
      imagePath: 'assets/images/MAIN CHARECTER1.png',
      cost: 0),
  Weapon(
      name: "Minus",
      description: "Becomes a bat. Throws away an enemy",
      imagePath: 'assets/images/MAIN CHARECTER1.png',
      cost: 0),
  Weapon(
      name: "Multiply",
      description: "Becomes a saw.",
      imagePath: 'assets/images/MAIN CHARECTER1.png',
      cost: 100)
];

class Weapon {
  Weapon(
      {required this.name,
      required this.description,
      required this.imagePath,
      required this.cost});
  String name;
  String description;
  String imagePath;
  int cost;
}
