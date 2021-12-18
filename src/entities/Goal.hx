package entities;

import spirit.components.SimpleBody;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.graphics.texturepacker.SpriteSheet;
import spirit.core.Entity;

class Goal extends Entity {

  public function init(options: GoalOptions): Goal {
    addComponent(Transform).init({ x: options.x, y: options.y, zIndex: 1 });
    addComponent(Sprite).init({ sheet: options.sheet, frameName: 'obj_tile_01' });
    addComponent(SimpleBody).init({ width: 10, height: 10, type: STATIC, isTrigger: true, tags: ['goal'] });

    return this;
  }
}

typedef GoalOptions = {
  var x: Float;
  var y: Float;
  var sheet: SpriteSheet;
}