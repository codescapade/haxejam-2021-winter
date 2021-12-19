package entities;

import spirit.components.SimpleBody;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.graphics.texturepacker.SpriteSheet;
import spirit.core.Entity;

class SpikeE extends Entity {

  public function init(options: SpikeEOptions): SpikeE {
    var sheet = assets.getSpriteSheet('sprites');
    addComponent(Transform).init({ x: options.x, y: options.y, zIndex: 1});
    addComponent(Sprite).init({ sheet: sheet, frameName: 'obj_tile_03' });
    addComponent(SimpleBody).init({ width: 20, height: 6, offset: { x: 0, y: 7 }, type: STATIC,
        isTrigger: true, tags: ['dead'] });

    return this;
  }
}

typedef SpikeEOptions = {
  var x: Float;
  var y: Float;
}