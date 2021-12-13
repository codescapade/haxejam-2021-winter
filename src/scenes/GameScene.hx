package scenes;

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
  var boxShape: BoxShape;

  var moving = false;

  var movingRight = false;
  public override function init() {
    addSystem(UpdateSystem).init();
    addSystem(RenderSystem).init();
    addSystem(SimplePhysicsSystem).init({ worldWidth: 800, worldHeight: 600 });


    var cam = addEntity(Entity);
    cam.addComponent(Transform).init();
    cam.addComponent(Camera).init();

    var floor = addEntity(Entity);
    floor.addComponent(Transform).init({ x: 400, y: 300 });
    floor.addComponent(BoxShape).init({ width: 200, height: 20, filled: true, hasStroke: false,
        fillColor: Color.fromValues(100, 100, 150, 255 )});

    var box = addEntity(Entity);
    boxTransform = box.addComponent(Transform).init({ x: 400, y: 280 });
    boxShape = box.addComponent(BoxShape).init({ width: 20, height: 20, filled: true, hasStroke: false,
        fillColor: Color.fromValues(100, 170, 180, 255 )});


    events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }


  function keyDown(event: KeyboardEvent) {
    if (event.keyCode == RIGHT) {
      if (moving) {
        return;
      }
      moving = true;

      movingRight = true;
      boxShape.anchorX = 1;
      boxShape.anchorY = 1;
      boxTransform.x += boxShape.width * 0.5;
      boxTransform.y += boxShape.height * 0.5;
      tweens.create(boxTransform, 0.5, { angle: boxTransform.angle + 90 }).setOnComplete(tweenComplete);
    } else if (event.keyCode == LEFT) {
      if (moving) {
        return;
      }
      moving = true;
      movingRight = false;
      boxShape.anchorX = 0;
      boxShape.anchorY = 1;
      boxTransform.x -= boxShape.width * 0.5;
      boxTransform.y += boxShape.height * 0.5;
      tweens.create(boxTransform, 0.5, { angle: boxTransform.angle - 90 }).setOnComplete(tweenComplete);
    }
  }

  function tweenComplete() {
    if (movingRight) {
      boxTransform.x += boxShape.width * 0.5;
    } else {
      boxTransform.x -= boxShape.width * 0.5;
    }

    boxTransform.y -= boxShape.width * 0.5;
    boxShape.anchorX = 0.5;
    boxShape.anchorY = 0.5;
    boxTransform.angle = 0;
    moving = false;
  }
}