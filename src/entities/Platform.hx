package entities;

import spirit.components.SimpleBody;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.graphics.texturepacker.SpriteSheet;
import spirit.core.Entity;

class Platform extends Entity {

  public function init(options: PlatformOptions): Platform {
    addComponent(Transform).init({ x: options.x, y: options.y, zIndex: 1});
    addComponent(Sprite).init({ sheet: options.sheet, frameName: 'obj_tile_02' });
    addComponent(SimpleBody).init({ width: 20, height: 4, offset: { x: 0, y: -8 },
        canCollide: TOP, tags: ['ground'], type: STATIC });

    return this;
  }
}

typedef PlatformOptions = {
  var x: Float;
  var y: Float;
  var sheet: SpriteSheet;
}