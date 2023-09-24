import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
//import 'package:flame/src/experimental/geometry/shapes/shape.dart';
import 'package:flutter/material.dart';
import 'package:lets_go/all_weapons.dart';
import 'package:lets_go/screens/game.dart';
//import 'package:flame/src/experimental/geometry/shapes/rectangle.dart';
import 'package:flame/experimental.dart';

enum Direction { left, right, idle, none }

bool isAttacking = false;

class Play extends FlameGame {
  World world = World();
  late final CameraComponent cameraComponent;

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
    cameraComponent = CameraComponent(world: world);
    addAll([cameraComponent, world]);

    _player.scale = Vector2.all(2);
    _enemy.scale = Vector2.all(2);
    _player.sizeOfBackground = _background.size;

    await world.add(_background);
    await world.add(_player);
    await world.add(_enemy);

    cameraComponent.follow(
      _player,
      /*worldBounds:
            Rect.fromLTRB(0, 0, _background.size.x, _background.size.y)*/
    );
    final halfViewportSize = cameraComponent.viewport.size;
    final worldSize = _background.size;
    cameraComponent.setBounds(
      Rectangle.fromCenter(
        center: worldSize / 2,
        size: worldSize - halfViewportSize,
      ),
    );
    // TODO: implement onLoad
    //cameraComponent.setBounds();
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

class Enemy extends SpriteAnimationComponent with HasGameRef {
  RectangleHitbox hitbox = RectangleHitbox();
  late final SpriteAnimation _idleAnimation;
  @override
  FutureOr<void> onLoad() async {
    _idleAnimation = await createAnimation(name: 'monster stand-Sheet.png', gameRef: gameRef, frames: 12, loop: true)/*SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('monster stand-Sheet.png'),
            columns: 12,
            rows: 1)
        .createAnimation(row: 0, stepTime: 0.1, from: 0, to: 11)*/;
    animation = _idleAnimation;
    anchor = Anchor.bottomCenter;
    x = gameRef.size[0] / 1.5;
    y = gameRef.size[1] / 2;
    await add(RectangleHitbox());
    // TODO: implement onLoad
    return super.onLoad();
  }
}

Future<SpriteAnimation> createAnimation({required String name, required FlameGame gameRef, required int frames, bool loop = false}) async {
  return SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load(name),
            columns: frames,
            rows: 1)
        .createAnimation(row: 0, stepTime: 0.1, from: 0, to: frames - 1, loop: loop);
}