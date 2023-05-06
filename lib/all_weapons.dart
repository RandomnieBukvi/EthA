import 'package:flutter/material.dart';

Map<String, Weapon> weapons = {
  'Plus': Weapon(
      description: "Becomes a shuriken. distance weapon",
      imagePath: '+',
      cost: 0),
  'Minus': Weapon(
      description: "Becomes a bat. Throws away an enemy",
      imagePath: '-',
      cost: 0),
  'Multiply': Weapon(description: "Becomes a saw.", imagePath: '*', cost: 100),
  'Divide': Weapon(description: "Becomes a spear. Can be used as close and distance weapon", imagePath: '/', cost: 100),
};

class Weapon {
  Weapon(
      {required this.description, required this.imagePath, required this.cost});
  String description;
  String imagePath;
  int cost;
}
