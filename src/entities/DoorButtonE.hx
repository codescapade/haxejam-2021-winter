package entities;

import spirit.components.SimpleBody;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.core.Entity;

class ButtonE extends Entity {

  public function init(options: ButtonEOptions): ButtonE {
    var sheet = assets.getSpriteSheet('sprites');
    addComponent(Transform).init({ x: options.x, y: options.y });

    var tags: Array<String> = [];
    var frame: String;
    switch (options.color) {
      case RED:
        tags.push('red_button');
        frame = 'obj_tile_05';

      case GREEN:
        tags.push('green_button');
        frame = 'obj_tile_07';

      case BLUE:
        tags.push('blue_button');
        frame = 'obj_tile_09';
    }

    addComponent(Sprite).init({ sheet: sheet, frameName: frame });
    addComponent(SimpleBody).init({ width: 20, height: 4, offset: { x: 0, y: 10 }, type: STATIC, isTrigger: true,
        tags: tags });

    return this;
  }
}

typedef ButtonEOptions = {
  var x: Float;
  var y: Float;
  var color: DoorColor;
}