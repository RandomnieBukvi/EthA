import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/all_weapons.dart';
import 'package:lets_go/game/enemy.dart';
import 'package:lets_go/screens/game.dart';
import 'package:lets_go/screens/game_flame.dart';

enum Direction { left, right, idle, none }

bool isAttacking = false;

class Player extends SpriteAnimationComponent with HasGameRef {
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
        if (weapons[element.wkey]?.onAnimationStart != null) {
          weapons[element.wkey]!.onAnimationStart!(this);
        }
        await animTicker?.completed.then((value) async {
          if (weapons[element.wkey]?.onAnimationEnd != null) {
            weapons[element.wkey]!.onAnimationEnd!(this);
          }
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
    memory.forEach((element) {
      if (element.index > index) element.index--;
    });
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
      playerSize: size,
    );
    add(playerHitbox);
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) {
    playerHitbox.position = Vector2(size.x / 2, size.y);
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

class PlayerHitbox extends RectangleHitbox {
  PlayerHitbox({required Vector2 playerSize})
      : super(
            isSolid: true,
            position: Vector2(playerSize.x / 2, playerSize.y),
            anchor: Anchor.bottomCenter,
            size: Vector2(32, 64));
  @override
  // TODO: implement debugColor
  Color get debugColor => Colors.yellow;
  @override
  void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
  }
}

class MinusHitbox extends RectangleHitbox {
  MinusHitbox({required Vector2 playerSize})
      : super(
            isSolid: true,
            position: Vector2(playerSize.x / 2, playerSize.y),
            anchor: Anchor.bottomLeft,
            size: Vector2(64, playerSize.y));
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    if (other.parent is Enemy)
      (other.parent as Enemy).velosity +=
          Vector2((parent as Player).isTurnedRight ? 150 : -150, -100);
    // TODO: implement onCollisionStart
    super.onCollisionStart(intersectionPoints, other);
  }
}

class Suriken extends SpriteComponent with HasGameRef, CollisionCallbacks {
  Suriken({required Enemy this.enemy});
  final Enemy enemy;
  /*await world.add(Suriken()
      ..scale = Vector2(2, 2)
      ..anchor = Anchor.center
      ..position = _enemy.position + Vector2(20, 0)
      ..add(RotateEffect.by(
          tau / 4,
          EffectController(
            duration: 0.2,
            infinite: true,
          ))));*/
  @override
  FutureOr<void> onLoad() async {
    print('suriken added');
    scale = Vector2.all(2);
    anchor = Anchor.center;
    add(RotateEffect.by(
          tau / 4,
          EffectController(
            duration: 0.1,
            infinite: true,
          )));
    sprite = await gameRef.loadSprite('suriken.png');
    add(RectangleHitbox(isSolid: true));
    add(MoveToEffect(enemy.position, EffectController(speed: 400),onComplete: () => removeFromParent(),));
    // TODO: implement onLoad
    return super.onLoad();
  }
  Vector2 ratio = Vector2.zero();
  /*@override
  void update(double dt) {
    ratio = position - enemy.position;
    position += Vector2(50 * ratio.x / ratio.y, 50 * ratio.y / ratio.x) * dt;
    // TODO: implement update
    super.update(dt);
  }*/

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    print(other);
    if (other is Enemy) {
      print('safkjasjlfsdfadsfafsadfasdfadsfa');
      removeFromParent();
      }
    // TODO: implement onCollisionStart
    super.onCollisionStart(intersectionPoints, other);
  }
}
