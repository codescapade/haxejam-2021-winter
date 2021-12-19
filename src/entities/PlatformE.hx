package entities;

import spirit.components.SimpleBody;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.core.Entity;

class PlatformE extends Entity {

  public function init(options: PlatformEOptions): PlatformE {
    var sheet = assets.getSpriteSheet('sprites');
    addComponent(Transform).init({ x: options.x, y: options.y, zIndex: 1});
    addComponent(Sprite).init({ sheet: sheet, frameName: 'obj_tile_02' });
    addComponent(SimpleBody).init({ width: 20, height: 4, offset: { x: 0, y: -8 }, canCollide: TOP, tags: ['ground'],
        type: STATIC });

    return this;
  }
}

typedef PlatformEOptions = {
  var x: Float;
  var y: Float;
}