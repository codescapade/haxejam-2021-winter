package entities;

import spirit.systems.SimplePhysicsSystem;
import spirit.components.SimpleBody;
import spirit.components.Sprite;
import spirit.components.Transform;
import spirit.core.Entity;

import components.PlayerMovement;

class PlayerE extends Entity {
  public var transform(default, null): Transform;

  public function init(options: PlayerEOptions): PlayerE {
    var sheet = assets.getSpriteSheet('sprites');
    transform = addComponent(Transform).init({ x: options.x, y: options.y, zIndex: 2 });
    addComponent(Sprite).init({ sheet: sheet, frameName: 'obj_tile_00' });
    addComponent(SimpleBody).init({ width: 20,  height: 20, type: DYNAMIC, tags: ['player'] });
    addComponent(PlayerMovement).init({ physics: options.physics, hook: options.hookTransform });
    options.hookTransform.parent = transform;

    return this;
  }
}

typedef PlayerEOptions = {
  var x: Float;
  var y: Float;
  var hookTransform: Transform;
  var physics: SimplePhysicsSystem;
}