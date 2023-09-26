import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
//import 'package:flame/src/experimental/geometry/shapes/shape.dart';
import 'package:lets_go/game/enemy.dart';
import 'package:lets_go/game/player.dart';
//import 'package:flame/src/experimental/geometry/shapes/rectangle.dart';
import 'package:flame/experimental.dart';

class Play extends FlameGame with HasCollisionDetection{
  World world = World();
  late final CameraComponent cameraComponent;

  var _background = GameBackground();
  late Vector2 worldSize;

  var _player = Player();
  onDirectionChanged(Direction dir) {
    _player.direction = dir;
  }

  attack(int index) {
    _player.attack(index);
  }

  late Enemy _enemy;

  @override
  FutureOr<void> onLoad() async {
    if(kDebugMode)  debugMode = true;
    cameraComponent = CameraComponent(world: world);
    addAll([cameraComponent, world]);
    _enemy = Enemy(player: _player, worldSize: _background.size);
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
    worldSize = _background.size;
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

Future<SpriteAnimation> createAnimation({required String name, required FlameGame gameRef, required int frames, bool loop = false}) async {
  return SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load(name),
            columns: frames,
            rows: 1)
        .createAnimation(row: 0, stepTime: 0.1, from: 0, to: frames - 1, loop: loop);
}