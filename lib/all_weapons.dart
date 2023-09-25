import 'package:flutter/material.dart';

Map<String, Weapon> weapons = {
  'Plus': Weapon(
      description: "Becomes a shuriken. distance weapon",
      operationSymbol: '+',
      cost: 0, damage: 7),
  'Minus': Weapon(
      description: "Becomes a bat. Throws away an enemy",
      operationSymbol: '-',
      cost: 0, damage:  10),
  'Multiply': Weapon(description: "Becomes a saw.", operationSymbol: '*', cost: 100, damage:  10),
  'Divide': Weapon(description: "Becomes a spear. Can be used as close and distance weapon", operationSymbol: '/', cost: 100, damage:  10),
};

class Weapon {
  Weapon(
      {required this.description, required this.operationSymbol, required this.cost, required this.damage});
  String description;
  String operationSymbol;
  int cost;
  double damage;
}
