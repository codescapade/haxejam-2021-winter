package entities;

import spirit.components.SimpleBody;
import components.Door;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.core.Entity;


class DoorE extends Entity {

  public function init(options: DoorEOptions): DoorE {
    var sheet = assets.getSpriteSheet('sprites');
    addComponent(Transform).init({ x: options.x, y: options.y });
    var frame: String;
    switch (options.color) {
      case RED:
        frame = 'obj_tile_04';

      case GREEN:
        frame = 'obj_tile_06';

      case BLUE:
        frame = 'obj_tile_08';
    }

    addComponent(Sprite).init({ sheet: sheet, frameName: frame });
    addComponent(Door).init({ color: options.color });
    addComponent(SimpleBody).init({ width: 20, height: 20, type: STATIC, tags: ['ground', 'door'] });
    return this;
  }
}

typedef DoorEOptions = {
  var x: Float;
  var y: Float;
  var color: DoorColor;
}