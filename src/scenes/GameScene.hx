package scenes;

import entities.Spike;
import entities.Platform;
import entities.Goal;
import entities.Player;
import entities.Hook;
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

@:enum
abstract TileObject(Int) from Int to Int {
  var PLAYER = 0;
  var GOAL = 1;
  var PLATFORM = 2;
  var SPIKES = 3;
  var RED_WALL = 4;
  var RED_BUTTON = 5;
  var GREEN_WALL = 6;
  var GREEN_BUTTON = 7;
  var BLUE_WALL = 8;
  var BLUE_BUTTON = 9;
}

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

    var hooks = addEntity(Entity);
    hooks.addComponent(Transform).init({ zIndex: 1 });
    tilemap = hooks.addComponent(Tilemap).init();
    tilemap.createFrom2dArray(tiledMap.tileLayers['hookpoints'], tileset);
    collider = hooks.addComponent(SimpleTilemapCollider).init();
    collider.setCollisions([2]);
    collider.addTag('hook');

    var tileSize = tileset.tileWidth;
    var objectGrid = tiledMap.tileLayers['objects'];
    var firstGid = tiledMap.tilesetFirstGid['object_tiles'];
    for (y in 0...objectGrid.length - 1) {
      for (x in 0...objectGrid[0].length - 1) {
        if (objectGrid[y][x] < 0) {
          continue;
        }
        var index: TileObject = objectGrid[y][x] - firstGid + 1;

        var xPos = x * tileSize + tileSize * 0.5;
        var yPos = y * tileSize + tileSize * 0.5;
        switch(index) {
          case PLAYER:
            var hook = addEntity(Hook).init();
            addEntity(Player).init({ x: xPos, y: yPos, sheet: sheet, physics: physics, hookTransform: hook.transform });

          case GOAL:
            addEntity(Goal).init({ x: xPos, y: yPos, sheet: sheet });

          case PLATFORM:
            addEntity(Platform).init({ x: xPos, y: yPos, sheet: sheet });

          case SPIKES:
            addEntity(Spike).init({ x: xPos, y: yPos, sheet: sheet });

          default:
        }
      }
    }
  }
}