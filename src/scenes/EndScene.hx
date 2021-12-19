package scenes;

import spirit.events.SceneEvent;
import spirit.events.input.KeyboardEvent;
import spirit.components.Text;
import spirit.components.Camera;
import spirit.components.Transform;
import spirit.core.Entity;
import spirit.systems.RenderSystem;
import spirit.core.Scene;

class EndScene extends Scene {

  public override function init() {
    addSystem(RenderSystem).init();

    var cam = addEntity(Entity);
    cam.addComponent(Transform).init();
    cam.addComponent(Camera).init();

    var font16 = assets.getBitmapFont('16px');
    var font32 = assets.getBitmapFont('32px');

    var thanks = addEntity(Entity);
    thanks.addComponent(Transform).init({ x: display.viewCenterX, y: 50 });
    thanks.addComponent(Text).init({ font: font32, text: 'Thanks for Playing!'});

    var me = addEntity(Entity);
    me.addComponent(Transform).init({ x: display.viewCenterX, y: 120 });
    me.addComponent(Text).init({ font: font16, text: 'a Game by Jurien Meerlo'});

    var jam = addEntity(Entity);
    jam.addComponent(Transform).init({ x: display.viewCenterX, y: 180 });
    jam.addComponent(Text).init({ font: font16, text: 'for HaxeJam 2021 Winter edition'});

    var press = addEntity(Entity);
    press.addComponent(Transform).init({ x: display.viewCenterX, y: 260 });
    press.addComponent(Text).init({ font: font16, text: 'Press space'});
    events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  function keyDown(event: KeyboardEvent) {
    if (event.keyCode == SPACE) {
      events.emit(SceneEvent.get(SceneEvent.REPLACE, MenuScene));
    }
  }
}