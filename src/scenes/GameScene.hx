package scenes;

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
  public override function init() {
    Game.debugDraw = true;
    addSystem(UpdateSystem).init();
    addSystem(RenderSystem).init();
    addSystem(SimplePhysicsSystem).init({ worldWidth: 640, worldHeight: 360, gravity: { x: 0, y: 1 } });

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

    var objects = tiledMap.objectLayers['objects'];
    for (object in objects) {
      if (object.name == 'player') {
        var box = addEntity(Entity);
        boxTransform = box.addComponent(Transform).init({ x: object.x + object.width * 0.5,
            y: object.y + object.height * 0.5, zIndex: 2 });
        boxSprite = box.addComponent(Sprite).init({ sheet: sheet, frameName: 'player' });
        body = box.addComponent(SimpleBody).init({ width: 20, height: 20, type: DYNAMIC });
      }
    }
    // var floor = addEntity(Entity);
    // floor.addComponent(Transform).init({ x: 400, y: 300 });
    // floor.addComponent(BoxShape).init({ width: 200, height: 20, filled: true, hasStroke: false,
    //     fillColor: Color.fromValues(100, 100, 150, 255 )});
    // floor.addComponent(SimpleBody).init({ width: 200, height: 20, type: STATIC });
    

    // var box = addEntity(Entity);
    // boxTransform = box.addComponent(Transform).init({ x: 400, y: 280 });
    // boxShape = box.addComponent(BoxShape).init({ width: 20, height: 20, filled: true, hasStroke: false,
    //     fillColor: Color.fromValues(100, 170, 180, 255 )});
    // box.addComponent(SimpleBody).init({ width: 20, height: 20, type: DYNAMIC });

    events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  function keyDown(event: KeyboardEvent) {
    if (event.keyCode == RIGHT) {
      if (moving) {
        return;
      }
      moving = true;
      body.active = false;
      movingRight = true;
      boxSprite.anchorX = 1;
      boxSprite.anchorY = 1;
      boxTransform.x += boxSprite.width * 0.5;
      boxTransform.y += boxSprite.height * 0.5;
      tweens.create(boxTransform, 0.5, { angle: boxTransform.angle + 90 }).setOnComplete(tweenComplete);
    } else if (event.keyCode == LEFT) {
      if (moving) {
        return;
      }
      moving = true;
      movingRight = false;
      body.active = false;
      boxSprite.anchorX = 0;
      boxSprite.anchorY = 1;
      boxTransform.x -= boxSprite.width * 0.5;
      boxTransform.y += boxSprite.height * 0.5;
      tweens.create(boxTransform, 0.5, { angle: boxTransform.angle - 90 }).setOnComplete(tweenComplete);
    }
  }

  function tweenComplete() {
    if (movingRight) {
      boxTransform.x += boxSprite.width * 0.5;
    } else {
      boxTransform.x -= boxSprite.width * 0.5;
    }

    boxTransform.y -= boxSprite.width * 0.5;
    boxSprite.anchorX = 0.5;
    boxSprite.anchorY = 0.5;
    boxTransform.angle = 0;
    body.active = true;
    moving = false;
  }
}