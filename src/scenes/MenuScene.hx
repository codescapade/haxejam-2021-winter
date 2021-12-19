package scenes;

import spirit.components.Text;
import spirit.components.Camera;
import spirit.events.SceneEvent;
import spirit.events.input.KeyboardEvent;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.core.Entity;
import spirit.systems.RenderSystem;
import spirit.core.Scene;

class MenuScene extends Scene {

  public override function init() {
    GameManager.instance.reset();

    addSystem(RenderSystem).init();

    var cam = addEntity(Entity);
    cam.addComponent(Transform).init();
    cam.addComponent(Camera).init();

    var sheet = assets.getSpriteSheet('sprites');
    var title = addEntity(Entity);
    title.addComponent(Transform).init({ x: display.viewCenterX, y: 30 });
    title.addComponent(Sprite).init({ sheet: sheet, frameName: 'title' });

    var cube = addEntity(Entity);
    cube.addComponent(Transform).init({ x: display.viewCenterX, y: 120, scaleX: 4, scaleY: 4 });
    cube.addComponent(Sprite).init({ sheet: sheet, frameName: 'obj_tile_00' });

    var tile1 = addEntity(Entity);
    tile1.addComponent(Transform).init({ x: display.viewCenterX - 80, y: 200, scaleX: 4, scaleY: 4 });
    tile1.addComponent(Sprite).init({ sheet: sheet, frameName: 'tile_05' });

    var tile2 = addEntity(Entity);
    tile2.addComponent(Transform).init({ x: display.viewCenterX, y: 200, scaleX: 4, scaleY: 4 });
    tile2.addComponent(Sprite).init({ sheet: sheet, frameName: 'tile_05' });

    var tile3 = addEntity(Entity);
    tile3.addComponent(Transform).init({ x: display.viewCenterX + 80, y: 200, scaleX: 4, scaleY: 4 });
    tile3.addComponent(Sprite).init({ sheet: sheet, frameName: 'tile_05' });

    var font = assets.getBitmapFont('20px');
    var text = addEntity(Entity);
    text.addComponent(Transform).init({ x: display.viewCenterX, y: 260 });
    text.addComponent(Text).init({ font: font, text: 'Press space to start' });

    events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  function keyDown(event: KeyboardEvent) {
    if (event.keyCode == SPACE) {
      events.emit(SceneEvent.get(SceneEvent.REPLACE, GameScene));
    }
  }
}