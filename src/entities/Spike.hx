package entities;

import spirit.components.SimpleBody;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.graphics.texturepacker.SpriteSheet;
import spirit.core.Entity;

class Spike extends Entity {

  public function init(options: SpikeOptions): Spike {
    addComponent(Transform).init({ x: options.x, y: options.y, zIndex: 1});
    addComponent(Sprite).init({ sheet: options.sheet, frameName: 'obj_tile_03' });
    addComponent(SimpleBody).init({ width: 20, height: 6, offset: { x: 0, y: 7 }, type: STATIC,
        isTrigger: true, tags: ['dead'] });

    return this;
  }
}

typedef SpikeOptions = {
  var x: Float;
  var y: Float;
  var sheet: SpriteSheet;
}