package scenes;

import spirit.events.SceneEvent;
import spirit.core.Scene;


class PreLoad extends Scene {

  public override function init() {
    assets.addSpriteSheet('sprites', 'assets/spritesheets/sprites.png', 'assets/spritesheets/sprites.json');

    events.emit(SceneEvent.get(SceneEvent.REPLACE, GameScene));
  }
}