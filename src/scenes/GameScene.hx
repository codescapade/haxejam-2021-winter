package scenes;

import spirit.components.Text;
import entities.DoorE;
import entities.DoorButtonE.ButtonE;
import systems.DoorSystem;
import components.CameraFollow;
import spirit.events.SceneEvent;
import entities.SpikeE;
import entities.PlatformE;
import entities.GoalE;
import entities.PlayerE;
import entities.HookE;
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

  var physics: SimplePhysicsSystem;

  var levelCompleteE: Entity;

  public override function init() {
    // Game.debugDraw = true;
    GameManager.instance.levelComplete = false;
    addSystem(UpdateSystem).init();
    addSystem(RenderSystem).init();
    physics = addSystem(SimplePhysicsSystem).init({ worldWidth: 640, worldHeight: 360, gravity: { x: 0, y: 550 } });
    addSystem(DoorSystem).init();

    var cam = addEntity(Entity);
    var camTransform = cam.addComponent(Transform).init();
    cam.addComponent(Camera).init({ zoom: 1 });

    loadLevel(cam);

    var font = assets.getBitmapFont('16px');
    levelCompleteE = addEntity(Entity);
    levelCompleteE.addComponent(Transform).init({ x: display.viewCenterX, y: display.viewCenterY, zIndex: 8, parent: camTransform });
    levelCompleteE.addComponent(Text).init({ font: font, text: 'Level Complete. Press space to continue' });
    levelCompleteE.active = false;

    physics.addInteractionListener(TRIGGER_START, 'death', 'player', (a: Body, b: Body) -> {
      events.emit(SceneEvent.get(SceneEvent.REPLACE, GameScene));
    });

    events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  public override function update(dt:Float) {
    super.update(dt);
    if (!levelCompleteE.active && GameManager.instance.levelComplete) {
      levelCompleteE.active = true;
    }
  }

  function keyDown(event: KeyboardEvent) {
    if (event.keyCode == ESCAPE) {
      events.emit(SceneEvent.get(SceneEvent.REPLACE, MenuScene));
    } else if (event.keyCode == SPACE && GameManager.instance.levelComplete) {
      if (GameManager.instance.nextLevel()) {
        events.emit(SceneEvent.get(SceneEvent.REPLACE, GameScene));
      } else {
        events.emit(SceneEvent.get(SceneEvent.REPLACE, EndScene));
      }
    }
  }

  function loadLevel(cam: Entity) {
    var mapData = assets.getText('assets/tilemaps/level${GameManager.instance.level}.json');
    var tilesetImage = assets.getImage('assets/tilemaps/tiles.png');
    var tileset = new Tileset(tilesetImage, 20, 20, 2, 1);
    var tiledMap = new TiledMap(tileset, mapData);
    var tileSize = tileset.tileWidth;
    var levelWidth = tiledMap.width * tileSize;
    var levelHeight = tiledMap.height * tileSize;
    physics.updateBounds(0, 0, levelWidth, levelHeight + 20);

    var deathBar = addEntity(Entity);
    deathBar.addComponent(Transform).init({ x: levelWidth * 0.5, y: levelHeight + 10 });
    deathBar.addComponent(SimpleBody).init({ width: levelWidth * 0.5, height: 20, type: STATIC, isTrigger: true,
        tags: ['death']});

    var background = addEntity(Entity);
    background.addComponent(Transform).init();
    var tilemap = background.addComponent(Tilemap).init();
    tilemap.createFrom2dArray(tiledMap.tileLayers['background'], tileset);

    var collision = addEntity(Entity);
    collision.addComponent(Transform).init({ zIndex: 1 });
    tilemap = collision.addComponent(Tilemap).init();
    tilemap.createFrom2dArray(tiledMap.tileLayers['floor'], tileset);
    var collider = collision.addComponent(SimpleTilemapCollider).init();
    collider.setCollisions([3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
    collider.addTag('ground');

    var hooks = addEntity(Entity);
    hooks.addComponent(Transform).init({ zIndex: 1 });
    tilemap = hooks.addComponent(Tilemap).init();
    tilemap.createFrom2dArray(tiledMap.tileLayers['hookpoints'], tileset);
    collider = hooks.addComponent(SimpleTilemapCollider).init();
    collider.setCollisions([2]);
    collider.addTag('hook');

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
            var hook = addEntity(HookE).init();
            var player = addEntity(PlayerE).init({ x: xPos, y: yPos, physics: physics, hookTransform: hook.transform });
            cam.addComponent(CameraFollow).init({ target: player.transform, speed: 2, minX: 0, minY: 0,
                maxX: levelWidth, maxY: levelHeight });

          case GOAL:
            addEntity(GoalE).init({ x: xPos, y: yPos });

          case PLATFORM:
            addEntity(PlatformE).init({ x: xPos, y: yPos });

          case SPIKES:
            addEntity(SpikeE).init({ x: xPos, y: yPos });
            
          case RED_BUTTON:
            addEntity(ButtonE).init({ x: xPos, y: yPos, color: RED });
            
          case RED_WALL:
            addEntity(DoorE).init({ x: xPos, y: yPos, color: RED });

          case GREEN_BUTTON:
            addEntity(ButtonE).init({ x: xPos, y: yPos, color: GREEN });

          case GREEN_WALL:
            addEntity(DoorE).init({ x: xPos, y: yPos, color: GREEN });
            
          case BLUE_BUTTON:
            addEntity(ButtonE).init({ x: xPos, y: yPos, color: BLUE });

          case BLUE_WALL:
            addEntity(DoorE).init({ x: xPos, y: yPos, color: BLUE });

          default:
        }
      }
    }
  }
}