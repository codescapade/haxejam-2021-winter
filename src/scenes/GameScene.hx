package scenes;

import spirit.graphics.Graphics;
import spirit.math.Vector2;
import spirit.physics.simple.Body;
import spirit.tween.easing.Easing;
import spirit.physics.simple.Collide;
import spirit.graphics.texturepacker.SpriteSheet;
import spirit.components.Sprite;
import spirit.components.SimpleTilemapCollider;
import spirit.components.Tilemap;
import spirit.tilemap.TiledMap;
import spirit.tilemap.Tileset;
import spirit.core.Game;
import spirit.components.SimpleBody;
import spirit.events.input.KeyboardEvent;
import spirit.graphics.Color;
import spirit.components.BoxShape;
import spirit.components.Camera;
import spirit.components.Transform;
import spirit.core.Entity;
import spirit.systems.SimplePhysicsSystem;
import spirit.systems.RenderSystem;
import spirit.systems.UpdateSystem;
import spirit.core.Scene;

class GameScene extends Scene {

  var boxTransform: Transform;
  var body: SimpleBody;
  var boxSprite: Sprite;

  var moving = false;

  var movingRight = false;

  var tempBodies: Array<Body> = [];

  var physics: SimplePhysicsSystem;

  var start = new Vector2();
  var end = new Vector2();

  public override function init() {
    // Game.debugDraw = true;
    addSystem(UpdateSystem).init();
    addSystem(RenderSystem).init();
    physics = addSystem(SimplePhysicsSystem).init({ worldWidth: 640, worldHeight: 360, gravity: { x: 0, y: 600 } });

    var cam = addEntity(Entity);
    cam.addComponent(Transform).init();
    cam.addComponent(Camera).init();

    var sheet = assets.addSpriteSheet('sprites', 'assets/spritesheets/sprites.png', 'assets/spritesheets/sprites.json');

    var mapData = assets.getText('assets/tilemaps/testLevel.json');
    var tilesetImage = assets.getImage('assets/tilemaps/tiles.png');
    var tileset = new Tileset(tilesetImage, 20, 20, 2, 1);
    var tiledMap = new TiledMap(tileset, mapData);

    var background = addEntity(Entity);
    background.addComponent(Transform).init();
    var tilemap = background.addComponent(Tilemap).init();
    tilemap.createFrom2dArray(tiledMap.tileLayers['background'], tileset);

    var collision = addEntity(Entity);
    collision.addComponent(Transform).init({ zIndex: 1 });
    tilemap = collision.addComponent(Tilemap).init();
    tilemap.createFrom2dArray(tiledMap.tileLayers['floor'], tileset);
    var collider = collision.addComponent(SimpleTilemapCollider).init();
    collider.setCollisions([1]);
    collider.addTag('ground');

    var objects = tiledMap.objectLayers['objects'];
    for (object in objects) {
      if (object.name == 'player') {
        var box = addEntity(Entity);
        boxTransform = box.addComponent(Transform).init({ x: object.x + object.width * 0.5,
            y: object.y + object.height * 0.5, zIndex: 2 });
        boxSprite = box.addComponent(Sprite).init({ sheet: sheet, frameName: 'player' });
        body = box.addComponent(SimpleBody).init({ width: 20, height: 20, type: DYNAMIC });
      } else if (object.name == 'platform') {
        var platform = addEntity(Entity);
        platform.addComponent(Transform).init({ x: object.x + object.width * 0.5, y: object.y + object.height * 0.5,
            zIndex: 1});
        platform.addComponent(Sprite).init({ sheet: sheet, frameName: 'platform' });
        platform.addComponent(SimpleBody).init({ width: object.width, height: object.height,
            canCollide: Collide.LEFT | Collide.RIGHT | Collide.TOP, tags: ['ground'] });
      }
    }

    events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  public override function render(graphics:Graphics) {
    super.render(graphics);

    graphics.color = Color.WHITE;
    graphics.drawLine(start.x, start.y, end.x, end.y);
  }

  function keyDown(event: KeyboardEvent) {
    if (event.keyCode == RIGHT) {
      if (moving) {
        return;
      }
      var worldPos = boxTransform.getWorldPosition();
      start.set(worldPos.x, worldPos.y);
      end.set(worldPos.x + 15, worldPos.y);
      while (tempBodies.length > 0) {
        tempBodies.pop();
      }
      physics.raycast(start, end, 'ground', tempBodies);

      worldPos.put();
      if (tempBodies.length > 0) {
        return;
      }

      var angle = Math.round(boxTransform.angle);
      if (angle == 0) {
        boxSprite.anchorX = 1;
        boxSprite.anchorY = 1;
      } else if (angle == 90) {
        boxSprite.anchorX = 1;
        boxSprite.anchorY = 0;
      }
      else if (angle == 180) {
        boxSprite.anchorX = 0;
        boxSprite.anchorY = 0;

      } else if (angle == 270) {
        boxSprite.anchorX = 0;
        boxSprite.anchorY = 1;

      }
      moving = true;
      body.active = false;
      movingRight = true;
      boxTransform.x += boxSprite.width * 0.5;
      boxTransform.y += boxSprite.height * 0.5;
      tweens.create(boxTransform, 0.3, { angle: boxTransform.angle + 90 }).setOnComplete(tweenComplete);
    } else if (event.keyCode == LEFT) {
      if (moving) {
        return;
      }

      var angle = Math.round(boxTransform.angle);
      if (angle == 0) {
        boxSprite.anchorX = 0;
        boxSprite.anchorY = 1;
      } else if (angle == 90) {
        boxSprite.anchorX = 1;
        boxSprite.anchorY = 1;
      }
      else if (angle == 180) {
        boxSprite.anchorX = 1;
        boxSprite.anchorY = 0;

      } else if (angle == 270) {
        boxSprite.anchorX = 0;
        boxSprite.anchorY = 0;
      }
      moving = true;
      movingRight = false;
      body.active = false;
      boxTransform.x -= boxSprite.width * 0.5;
      boxTransform.y += boxSprite.height * 0.5;
      tweens.create(boxTransform, 0.3, { angle: boxTransform.angle - 90 }).setOnComplete(tweenComplete);
    } else if (event.keyCode == UP) {
      if (boxTransform.angle == 0) {
        if (body.active) {
          body.velocity.y = -280;
        }
      } else if (boxTransform.angle == 90) {
        moving = true;
        body.active = false;
        tweens.create(boxTransform, 0.25, { x: boxTransform.x + 20 }).setEase(Easing.easeOutCubic).setOnComplete(pushComplete);
      } else if (boxTransform.angle == 270) {
        moving = true;
        body.active = false;
        tweens.create(boxTransform, 0.25, { x: boxTransform.x - 20 }).setEase(Easing.easeOutCubic).setOnComplete(pushComplete);
      }
    }
  }

  function tweenComplete() {
    if (movingRight) {
      boxTransform.x += boxSprite.width * 0.5;
    } else {
      boxTransform.x -= boxSprite.width * 0.5;
    }

    if (boxTransform.angle >= 360) {
      boxTransform.angle -= 360;
    } else if (boxTransform.angle < 0) {
      boxTransform.angle += 360;
    }
    boxTransform.y -= boxSprite.width * 0.5;
    boxSprite.anchorX = 0.5;
    boxSprite.anchorY = 0.5;
    body.active = true;
    moving = false;
  }

  function pushComplete() {
    body.active = true;
    moving = false;
  }
}