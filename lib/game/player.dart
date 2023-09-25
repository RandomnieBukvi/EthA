import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/all_weapons.dart';
import 'package:lets_go/screens/game.dart';
import 'package:lets_go/screens/game_flame.dart';

enum Direction { left, right, idle, none }

bool isAttacking = false;

class Player extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  Player({this.sizeOfBackground});
  double speed = 120;
  Vector2? sizeOfBackground;
  bool isTurnedRight = true;
  Direction direction = Direction.idle;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _walkAnimation;
  late ValueChanged<Function()> doFunct;
  Map<String, SpriteAnimation> operationSymbolToAnimation = {};
  late RectangleHitbox playerHitbox;

  attack(int index) async {
    print('ATTACCCCCCCCCCCCCCCCCCCCC');
    direction = Direction.none;
    List<WeaponBoxGame> buf = memory[index].chosedOrder;
    int i = 1;
    for (WeaponBoxGame element in buf) {
      print('${element.wkey}');
      if (operationSymbolToAnimation[weapons[element.wkey]?.operationSymbol] !=
          null) {
        print('passed');
        SpriteAnimation anim =
            operationSymbolToAnimation[weapons[element.wkey]!.operationSymbol]!
                .clone();

        anim.loop = false;
        animation = anim;
        var animTicker = animationTicker;
        await animTicker?.completed.then((value) async {
          print("ANimATion played");
          animation = _idleAnimation;
          await Future.delayed(Duration(milliseconds: 100));
          if (i == buf.length) {
            print('DONE');
            isAttacking = false;
          }
        });
        print('done?');
      } else if (i == buf.length) {
        print('DONE');
        isAttacking = false;
      }
      i++;
    }
    doArrowsWork = true;
    direction = Direction.idle;
  }

  @override
  FutureOr<void> onLoad() async {
    //add(RectangleHitbox(isSolid: true));
    _idleAnimation = await createAnimation(
        name: 'stand fish-Sheet.png', gameRef: gameRef, frames: 12, loop: true);
    _walkAnimation = await createAnimation(
        name: 'walking fish-Sheet.png',
        gameRef: gameRef,
        frames: 8,
        loop: true);
    ////Map который поможет сопостовлять операции с их анимацией
    operationSymbolToAnimation = {
      '-': await createAnimation(
          name: 'sword attack-Sheet.png', gameRef: gameRef, frames: 9),
      '*': await createAnimation(
          name: 'benzapilaa attack-Sheet.png', gameRef: gameRef, frames: 15),
      '/': await createAnimation(
          name: 'spear attack-Sheet.png', gameRef: gameRef, frames: 9),
      '+': await createAnimation(
          name: 'attack suriken-Sheet.png', gameRef: gameRef, frames: 10),
    };
    animation = _idleAnimation;
    anchor = Anchor.bottomCenter;
    x = gameRef.size[0] / 4;
    y = gameRef.size[1] / 2;
    playerHitbox = PlayerHitbox(
        isSolid: true,
        anchor: Anchor.bottomCenter,
        size: Vector2(32, 64),
        position: Vector2(size.x / 2, size.y));
    playerHitbox.debugColor = Colors.yellow;
    add(playerHitbox);
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) {
    playerHitbox.position = Vector2(size.x / 2, size.y);
    print(size);
    if (dontShowArrows == true) {
      animation = _idleAnimation;
    } else {
      // print(direction);
      switch (direction) {
        case Direction.idle:
          animation = _idleAnimation;
          break;
        case Direction.right:
          if (0 < position.x + speed * dt &&
              position.x + speed * dt < sizeOfBackground![0]) {
            position.x += speed * dt;
          }
          if (isTurnedRight == false) {
            isTurnedRight = true;
            flipHorizontally();
          }
          animation = _walkAnimation;

          break;
        case Direction.left:
          if (0 < position.x - speed * dt &&
              position.x - speed * dt < sizeOfBackground![0]) {
            position.x -= speed * dt;
          }
          if (isTurnedRight == true) {
            isTurnedRight = false;
            flipHorizontally();
          }
          animation = _walkAnimation;
          break;
        case Direction.none:
          break;
      }
    }
    // TODO: implement update
    super.update(dt);
  }
}

class PlayerHitbox extends RectangleHitbox{
  PlayerHitbox({isSolid, position, anchor, size}) : super(isSolid: isSolid, position: position, anchor: anchor, size: size);
  @override
  void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
  }
}