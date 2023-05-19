import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/all_weapons.dart';
import 'package:lets_go/screens/game.dart';

enum Direction { left, right, idle, none }

bool isAttacking = false;

class Play extends FlameGame {
  var _background = GameBackground();

  var _player = Player();
  onDirectionChanged(Direction dir) {
    _player.direction = dir;
  }

  attack(int index) {
    _player.attack(index);
  }

  var _enemy = Enemy();

  @override
  FutureOr<void> onLoad() async {
    await add(_background);
    await add(_player);
    await add(_enemy);
    _player.scale = Vector2.all(2);
    _enemy.scale = Vector2.all(2);
    _player.flip = _player.flipHorizontally;
    _player.sizeOfBackground = _background.size;
    camera.followComponent(_player,
        worldBounds:
            Rect.fromLTRB(0, 0, _background.size.x, _background.size.y));
    // TODO: implement onLoad
    return super.onLoad();
  }
}

class GameBackground extends SpriteComponent with HasGameRef {
  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    sprite = await gameRef.loadSprite('game background.png');
    height = gameRef.size[1];
    width = gameRef.size[1] / sprite!.originalSize[1] * sprite!.originalSize[0];
    return super.onLoad();
  }
}

class Player extends SpriteAnimationComponent with HasGameRef {
  Player({this.flip, this.sizeOfBackground});
  double speed = 120;
  Function()? flip;
  Vector2? sizeOfBackground;
  bool isTurnedRight = true;
  Direction direction = Direction.idle;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _walkAnimation;
  late ValueChanged<Function()> doFunct;
  Map<String, SpriteAnimation> operationSymbolToAnimation = {};

  attack(int index) async {
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
        setAnimation(anim);
        await anim.completed.then((value) async {
          print("ANimATion played");
          anim.loop = true;
          setAnimation(_idleAnimation);
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

  setAnimation(SpriteAnimation value) {
    animation = value;
    return animation;
  }

  @override
  FutureOr<void> onLoad() async {
    _idleAnimation = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('stand fish-Sheet.png'),
            columns: 12,
            rows: 1)
        .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 11);
    _walkAnimation = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('walking fish-Sheet.png'),
            columns: 8,
            rows: 1)
        .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 7);
    ////Map который поможет сопостовлять операции с их анимацией
    operationSymbolToAnimation = {
      '-': SpriteSheet.fromColumnsAndRows(
              image: await gameRef.images.load('sword attack-Sheet.png'),
              columns: 9,
              rows: 1)
          .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 8),
      '*': SpriteSheet.fromColumnsAndRows(
              image: await gameRef.images.load('benzapilaa attack-Sheet.png'),
              columns: 15,
              rows: 1)
          .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 14),
      '/': SpriteSheet.fromColumnsAndRows(
              image: await gameRef.images.load('spear attack-Sheet.png'),
              columns: 9,
              rows: 1)
          .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 8),
      '+': SpriteSheet.fromColumnsAndRows(
              image: await gameRef.images.load('attack suriken-Sheet.png'),
              columns: 10,
              rows: 1)
          .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 9),
    };
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
      print(direction);
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
            flip!();
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
            flip!();
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

class Enemy extends SpriteAnimationComponent with HasGameRef {
  RectangleHitbox hitbox = RectangleHitbox();
  late final SpriteAnimation _idleAnimation;
  @override
  FutureOr<void> onLoad() async {
    _idleAnimation = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('monster stand-Sheet.png'),
            columns: 12,
            rows: 1)
        .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 11);
    animation = _idleAnimation;
    anchor = Anchor.bottomCenter;
    x = gameRef.size[0] / 1.5;
    y = gameRef.size[1] / 2;
    await add(RectangleHitbox());
    // TODO: implement onLoad
    return super.onLoad();
  }
}
