package components;

import scenes.GameScene;
import spirit.events.SceneEvent;
import spirit.physics.simple.Collide;
import spirit.physics.simple.Hit;
import spirit.tween.easing.Easing;
import spirit.physics.simple.Body;
import spirit.math.Vector2;
import spirit.core.Updatable;
import spirit.events.input.KeyboardEvent;
import spirit.systems.SimplePhysicsSystem;
import spirit.components.SimpleBody;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.core.Component;

class PlayerMovement extends Component implements Updatable {

  var transform: Transform;
  var sprite: Sprite;
  var body: SimpleBody;

  var hookTransform: Transform;

  var physics: SimplePhysicsSystem;

  var moving = false;

  var rayStart = new Vector2();
  var rayEnd = new Vector2();

  var hits: Array<Hit> = [];

  var groundTag = ['ground', 'hook'];

  var hookTag = ['hook'];

  var grounded = false;

  var jumping = false;

  var leftDown = false;

  var rightDown = false;

  var onHook = false;

  var complete = false;

  var hookStartPos = new Vector2();
  var hookHitPos = new Vector2();
  
  public override function cleanup() {
    events.off(KeyboardEvent.KEY_DOWN, keyDown);   
    events.off(KeyboardEvent.KEY_UP, keyUp);
  }

  public function init(options: PlayerMovementOptions) {
    physics = options.physics;
    hookTransform = options.hook;
    transform = getComponent(Transform);
    sprite = getComponent(Sprite);
    body = getComponent(SimpleBody);

    events.on(KeyboardEvent.KEY_DOWN, keyDown);   
    events.on(KeyboardEvent.KEY_UP, keyUp);

    physics.addInteractionListener(TRIGGER_START, 'goal', 'player', hitGoal);
  }

  public function update(dt: Float) {
    updateGrounded();

    if (onHook) {
      hookStartPos.set(transform.x, transform.y);
      var dist = Vector2.distance(hookStartPos, hookHitPos);
      hookTransform.scaleY = dist;
      var angle = transform.angle;
      if (angle == 0) {
        if (body.touching.contains(TOP)) {
          onHook = false;
          body.useGravity = true;
          hookTransform.scaleY = 1;
        }
      } else if (angle == 90) {
        if (body.touching.contains(RIGHT)) {
          onHook = false;
          body.useGravity = true;
          hookTransform.scaleY = 1;
        }
      } else if (angle == 180) {
        if (body.touching.contains(BOTTOM)) {
          onHook = false;
          body.useGravity = true;
          hookTransform.scaleY = 1;
        }
      } else if (angle == 270) {
        if (body.touching.contains(LEFT)) {
          onHook = false;
          body.useGravity = true;
          hookTransform.scaleY = 1;
        }
      }
    }
  }


  function keyDown(event: KeyboardEvent) {
    if (onHook || complete) {
      if (complete && event.keyCode == RETURN) {
        events.emit(SceneEvent.get(SceneEvent.REPLACE, GameScene));
      }
      return;
    }

    final angle = transform.angle;
    if (event.keyCode == X && !moving) {
      if (grounded) {
        if (angle == 0 && body.active) {
          if (body.active) {
            body.velocity.y = -290;
            jumping = true;
          }
        } else if (angle == 90 && canMoveRight()) {
          moving = true;
          body.active = false;
          tweens.create(transform, 0.25, { x: transform.x + 20})
            .setEase(Easing.easeOutCubic)
            .setOnComplete(pushComplete);
        } else if (angle == 270 && canMoveLeft()) {
          moving = true;
          body.active = false;
          tweens.create(transform, 0.25, { x: transform.x - 20})
            .setEase(Easing.easeOutCubic)
            .setOnComplete(pushComplete);
        }
      }
    } else if (event.keyCode == C && !moving) {
      if (!onHook) {
        rayStart.set(transform.x, transform.y);
        var collide: Collide = NONE;
        if (angle == 0) {
          rayEnd.set(transform.x, transform.y - 120);
          collide = BOTTOM;
        } else if (angle == 90) {
          rayEnd.set(transform.x + 120, transform.y);
          collide = LEFT;
        } else if (angle == 180) {
          rayEnd.set(transform.x, transform.y + 120);
          collide = TOP;
        } else if (angle == 270) {
          rayEnd.set(transform.x - 120, transform.y);
          collide = RIGHT;
        }
        clearHits();
        physics.raycast(rayStart, rayEnd, hookTag, hits);
        if (hits.length > 0) {
          for (hit in hits) {
            if (!hit.body.canCollide.contains(collide)) {
              continue;
            }
            onHook = true;
            body.useGravity = false;
            hookStartPos.copyFrom(rayStart);
            hookHitPos.copyFrom(hits[0].position);
            if (angle == 0) {
              body.velocity.set(0, -220);
            } else if (angle == 90) {
              body.velocity.set(220, 0);
            } else if (angle == 180) {
              body.velocity.set(0, 220);
            } else if (angle == 270) {
              body.velocity.set(-220, 0);
            }
          }
        }

        if (!onHook) {
          hookTransform.scaleY = 120;
          tweens.create(hookTransform, 0.1, { scaleY: 1 });
        }
      }
    } else if (event.keyCode == LEFT) {
      leftDown = true;
      if (!moving) {
        if (jumping && angle == 0) {
          tweens.create(transform, 0.1, { angle: transform.angle - 90 }).setOnComplete(airRollComplete);
        } else if (grounded && canMoveLeft()) {
          rollLeft();
        }
      }
    } else if (event.keyCode == RIGHT && !moving) {
      rightDown = true;
      if (!moving) {
        if (jumping && angle == 0) {
          tweens.create(transform, 0.1, { angle: transform.angle + 90 }).setOnComplete(airRollComplete);
        } else if (grounded && canMoveRight()) {
          rollRight();
        }
      }
    }
  }

  function keyUp(event: KeyboardEvent) {
    if (event.keyCode == LEFT) {
      leftDown = false;
    } else if (event.keyCode == RIGHT) {
      rightDown = false;
    }
  }

  function rollLeft() {
    setRollLeftAnchor(transform.angle);
    body.active = false;
    moving = true;
    transform.x -= sprite.width * 0.5;
    transform.y += sprite.width * 0.5;
    tweens.create(transform, 0.3, { angle: transform.angle - 90 }).setOnComplete(rollLeftComplete);
  }

  function rollRight() {
    setRollRightAnchor(transform.angle);
    body.active = false;
    moving = true;
    transform.x += sprite.width * 0.5;
    transform.y += sprite.width * 0.5;
    tweens.create(transform, 0.3, { angle: transform.angle + 90 }).setOnComplete(rollRightComplete);
  }

  function airRollComplete() {
    normalizeRotation();
    moving = false;
  }

  function rollLeftComplete() {
    transform.x -= sprite.width * 0.5;
    rollComplete();
    if (leftDown) {
    updateGrounded();
      if (grounded && canMoveLeft()) {
        rollLeft();
      }
    }
  }

  function rollRightComplete() {
    transform.x += sprite.width * 0.5;
    rollComplete();
    if (rightDown) {
      updateGrounded();
      if (grounded && canMoveRight()) {
        rollRight();
      }
    }
  }

  function rollComplete() {
    normalizeRotation();
    transform.y -= sprite.width * 0.5;
    sprite.anchorX = 0.5;
    sprite.anchorY = 0.5;
    body.active = true;
    moving = false;
  }

  function pushComplete() {
    body.active = true;
    moving = false;
  }

  function updateGrounded() {
    grounded = false;
    if (body.velocity.y < 0) {
      return;
    }
    clearHits();
    rayStart.set(transform.x, transform.y);
    rayEnd.set(transform.x, transform.y + 12);
    physics.raycast(rayStart, rayEnd, groundTag, hits);
    
    if (hits.length > 0) {
      grounded = true;
      jumping = false;
    }
  }

  function canMoveLeft() {
    clearHits();
    rayStart.set(transform.x, transform.y);
    rayEnd.set(transform.x - 12 ,transform.y);
    physics.raycast(rayStart, rayEnd, groundTag, hits);

    return hits.length == 0;
  }

  function canMoveRight() {
    clearHits();
    rayStart.set(transform.x, transform.y);
    rayEnd.set(transform.x + 12 ,transform.y);
    physics.raycast(rayStart, rayEnd, groundTag, hits);

    return hits.length == 0;
  }

  function clearHits() {
    while (hits.length > 0) {
      hits.pop();
    }
  }

  function setRollLeftAnchor(angle: Float) {
    if (angle == 0) {
      sprite.anchorX = 0;
      sprite.anchorY = 1;
    } else if (angle == 90) {
      sprite.anchorX = 1;
      sprite.anchorY = 1;
    } else if (angle == 180) {
      sprite.anchorX = 1;
      sprite.anchorY = 0;
    } else if (angle == 270) {
      sprite.anchorX = 0;
      sprite.anchorY = 0;
    }
  }

  function setRollRightAnchor(angle: Float) {
    if (angle == 0) {
      sprite.anchorX = 1;
      sprite.anchorY = 1;
    } else if (angle == 90) {
      sprite.anchorX = 1;
      sprite.anchorY = 0;
    } else if (angle == 180) {
      sprite.anchorX = 0;
      sprite.anchorY = 0;
    } else if (angle == 270) {
      sprite.anchorX = 0;
      sprite.anchorY = 1;
    }
  }

  function normalizeRotation() {
    // Keep the angle between 0 and 360.
    if (transform.angle >= 360) {
      transform.angle -= 360;
    } else if (transform.angle < 0) {
      transform.angle += 360;
    }
  }

  function hitGoal(a: Body, b: Body) {
    if (!moving) {
      complete = true;
    }
  }

  override function get_requiredComponents():Array<Class<Component>> {
    return [Transform, Sprite, SimpleBody];
  }
}

typedef PlayerMovementOptions = {
  var physics: SimplePhysicsSystem;
  var hook: Transform;
}