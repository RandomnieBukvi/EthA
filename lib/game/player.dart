import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/all_weapons.dart';
import 'package:lets_go/screens/game.dart';
import 'package:lets_go/screens/game_flame.dart';

enum Direction { left, right, idle, none }

bool isAttacking = false;

class Player extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  Player({this.sizeOfBackground});
  double speed = 120;
  Vector2? sizeOfBackground;
  bool isTurnedRight = true;
  Direction direction = Direction.idle;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _walkAnimation;
  late ValueChanged<Function()> doFunct;
  Map<String, SpriteAnimation> operationSymbolToAnimation = {};

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
        //setAnimation(anim);
        await animTicker?.completed.then((value) async {
          print("ANimATion played");
          //anim.loop = true;
          animation = _idleAnimation;
          //setAnimation(_idleAnimation);
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

  /*setAnimation(SpriteAnimation value) {
    animation = value;
    return animation;
  }*/

  @override
  FutureOr<void> onLoad() async {
    add(RectangleHitbox(isSolid: true));
    _idleAnimation = await createAnimation(name: 'stand fish-Sheet.png', gameRef: gameRef, frames: 12, loop: true)/*SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('stand fish-Sheet.png'),
            columns: 12,
            rows: 1)
        .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 11)*/;
    _walkAnimation = await createAnimation(name: 'walking fish-Sheet.png', gameRef: gameRef, frames: 8, loop: true)/*SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('walking fish-Sheet.png'),
            columns: 8,
            rows: 1)
        .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 7)*/;
    ////Map который поможет сопостовлять операции с их анимацией
    operationSymbolToAnimation = {
      '-': await createAnimation(name: 'sword attack-Sheet.png', gameRef: gameRef, frames: 9)/*SpriteSheet.fromColumnsAndRows(
              image: await gameRef.images.load('sword attack-Sheet.png'),
              columns: 9,
              rows: 1)
          .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 8)*/,
      '*': await createAnimation(name: 'benzapilaa attack-Sheet.png', gameRef: gameRef, frames: 15)/*SpriteSheet.fromColumnsAndRows(
              image: await gameRef.images.load('benzapilaa attack-Sheet.png'),
              columns: 15,
              rows: 1)
          .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 14)*/,
      '/': await createAnimation(name: 'spear attack-Sheet.png', gameRef: gameRef, frames: 9)/*SpriteSheet.fromColumnsAndRows(
              image: await gameRef.images.load('spear attack-Sheet.png'),
              columns: 9,
              rows: 1)
          .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 8)*/,
      '+': await createAnimation(name: 'attack suriken-Sheet.png', gameRef: gameRef, frames: 10)/*SpriteSheet.fromColumnsAndRows(
              image: await gameRef.images.load('attack suriken-Sheet.png'),
              columns: 10,
              rows: 1)
          .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 9)*/,
    };
    /*animations = {
      'idle': _idleAnimation,
      'walk': _walkAnimation,
      ...operationSymbolToAnimation
    };*/
    animation = _idleAnimation;
    anchor = Anchor.bottomCenter;
    x = gameRef.size[0] / 4;
    y = gameRef.size[1] / 2;
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) {
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
    /*width = animation!.frames[0].sprite.originalSize[0];
    height = animation!.frames[0].sprite.originalSize[1];*/
    // TODO: implement update
    super.update(dt);
  }
}