package entities;

import spirit.components.SimpleBody;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.core.Entity;

class GoalE extends Entity {

  public function init(options: GoalEOptions): GoalE {
    var sheet = assets.getSpriteSheet('sprites');
    addComponent(Transform).init({ x: options.x, y: options.y, zIndex: 1 });
    addComponent(Sprite).init({ sheet: sheet, frameName: 'goal' });
    addComponent(SimpleBody).init({ width: 10, height: 10, type: STATIC, isTrigger: true, tags: ['goal'] });

    return this;
  }
}

typedef GoalEOptions = {
  var x: Float;
  var y: Float;
}