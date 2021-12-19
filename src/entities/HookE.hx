package entities;

import spirit.components.BoxShape;
import spirit.graphics.Color;
import spirit.components.Transform;
import spirit.core.Entity;

class HookE extends Entity {

  public var transform: Transform;

  public function init(): HookE {
    transform = addComponent(Transform).init({ zIndex: 0, scaleY: 1 });
    final color = Color.fromValues(120, 80, 40, 255);
    addComponent(BoxShape).init({ anchorY: 1, width: 4, height: 1, filled: true, fillColor: color, hasStroke: false});

    return this;
  }
}