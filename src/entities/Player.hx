package entities;

import spirit.systems.SimplePhysicsSystem;
import spirit.components.SimpleBody;
import spirit.components.Sprite;
import spirit.graphics.texturepacker.SpriteSheet;
import spirit.components.Transform;
import spirit.core.Entity;

import components.PlayerMovement;

class Player extends Entity {

  public function init(options: PlayerOptions): Player {
    var transform = addComponent(Transform).init({ x: options.x, y: options.y, zIndex: 2 });
    addComponent(Sprite).init({ sheet: options.sheet, frameName: 'obj_tile_00' });
    addComponent(SimpleBody).init({ width: 20,  height: 20, type: DYNAMIC, tags: ['player'] });
    addComponent(PlayerMovement).init({ physics: options.physics, hook: options.hookTransform });
    options.hookTransform.parent = transform;

    return this;
  }
}

typedef PlayerOptions = {
  var x: Float;
  var y: Float;
  var sheet: SpriteSheet;
  var hookTransform: Transform;
  var physics: SimplePhysicsSystem;
}