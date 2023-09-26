import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/game/enemy.dart';
import 'package:lets_go/game/player.dart';

Map<String, Weapon> weapons = {
  'Plus': Weapon(
      description: "Becomes a shuriken. distance weapon",
      operationSymbol: '+',
      cost: 0,
      damage: 7,
      onAnimationStart: (player) {
        Enemy enemy = player.parent!.children.whereType<Enemy>().first;
        player.parent!.add(Suriken(enemy: enemy)..position = player.position - Vector2(player.size.y / 2,0));
      },
      ),
  'Minus': Weapon(
    description: "Becomes a sword. Throws away an enemy",
    operationSymbol: '-',
    cost: 0,
    damage: 10,
    onAnimationStart: (player) {
      player.add(MinusHitbox(playerSize: player.size));
    },
    onAnimationEnd: (player) {
      player.children.whereType<MinusHitbox>().forEach((element) { 
        element.removeFromParent();
      });
    },
  ),
  'Multiply': Weapon(
      description: "Becomes a saw.",
      operationSymbol: '*',
      cost: 100,
      damage: 10),
  'Divide': Weapon(
      description: "Becomes a spear. Can be used as close and distance weapon",
      operationSymbol: '/',
      cost: 100,
      damage: 10),
};

class Weapon {
  Weapon(
      {required this.description,
      required this.operationSymbol,
      required this.cost,
      required this.damage,
      this.onAnimationStart,
      this.onAnimationEnd});
  String description;
  String operationSymbol;
  int cost;
  double damage;
  void Function(Player)? onAnimationStart;
  void Function(Player)? onAnimationEnd;
}
