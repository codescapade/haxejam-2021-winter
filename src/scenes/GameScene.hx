package scenes;

import components.PlayerMovement;
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

  var moving = false;

  var movingRight = false;

  var physics: SimplePhysicsSystem;

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
        var player = addEntity(Entity);
        var boxTransform = player.addComponent(Transform).init({ x: object.x + object.width * 0.5,
            y: object.y + object.height * 0.5, zIndex: 2 });
        player.addComponent(Sprite).init({ sheet: sheet, frameName: 'player' });
        player.addComponent(SimpleBody).init({ width: 20, height: 20, type: DYNAMIC, tags: ['player'] });

        var hook = addEntity(Entity);
        var hookTransform = hook.addComponent(Transform).init({ zIndex: 0, parent: boxTransform, scaleY: 1 });
        hook.addComponent(BoxShape).init({ anchorY: 1, width: 4, height: 1, filled: true,
            fillColor: Color.fromValues(120, 80, 40, 255), hasStroke: false });

        player.addComponent(PlayerMovement).init({ physics: physics, hook: hookTransform });
      } else if (object.name == 'platform') {
        var platform = addEntity(Entity);
        platform.addComponent(Transform).init({ x: object.x + object.width * 0.5, y: object.y + object.height * 0.5,
            zIndex: 1});
        platform.addComponent(Sprite).init({ sheet: sheet, frameName: 'platform' });
        platform.addComponent(SimpleBody).init({ width: object.width, height: object.height,
            canCollide: Collide.TOP, tags: ['ground'], type: STATIC });
      } else if (object.name == 'goal') {
        var goal = addEntity(Entity);
        goal.addComponent(Transform).init({ x: object.x + object.width * 0.5, y: object.y + object.height * 0.5,
            zIndex: 1});
        goal.addComponent(Sprite).init({ sheet: sheet, frameName: 'goal' });
        goal.addComponent(SimpleBody).init({ width: 10, height: 10, type: STATIC, isTrigger: true, tags: ['goal'] });
      }
    }
  }
}