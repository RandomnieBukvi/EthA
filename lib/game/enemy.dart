import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:lets_go/game/player.dart';
import 'package:lets_go/screens/game_flame.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  Enemy({required this.player, required this.worldSize});
  bool isTurnedRight = false;
  final Player player;
  late final SpriteAnimation _idleAnimation;
  bool isOnGround = true;
  final gravity = 9.8;
  var velosity = Vector2(0, 0);
  final double jumpHeight = -250;
  double jumpDelay = 2;
  final double jumpDelayConst = 2;
  final double speed = 100;
  late Vector2 worldSize;
  @override
  FutureOr<void> onLoad() async {
    _idleAnimation = await createAnimation(name: 'monster stand-Sheet.png', gameRef: gameRef, frames: 12, loop: true);
    animation = _idleAnimation;
    anchor = Anchor.bottomCenter;
    x = gameRef.size[0] / 1.5;
    y = gameRef.size[1] / 2.1;
    await add(RectangleHitbox(isSolid: true));
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) {
    isOnGround = position.y > worldSize.y / 2;
    if(isOnGround){
      position.y = worldSize.y / 2;
      velosity = Vector2.zero();
      jumpDelay -= dt;
    }else{
      velosity.y += gravity;
    }

    if(position.x + velosity.x * dt <= 0 || position.x + velosity.x * dt >= worldSize.x) velosity.x = 0;

    if(jumpDelay <= 0){
      jumpDelay = jumpDelayConst;
      velosity.y = jumpHeight;
      velosity.x = isTurnedRight ? speed : -speed;
    }
    
    position += velosity * dt;

    if(player.position.x < position.x && isTurnedRight == true) {
      flipHorizontally();
      isTurnedRight = false;
    } 
    if(player.position.x > position.x && isTurnedRight == false) {
      flipHorizontally();
      isTurnedRight = true;
    }
    // TODO: implement update
    super.update(dt);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollisionStart(intersectionPoints, other);
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
  }
  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    super.onCollisionEnd(other);
  }
}