package scenes;

import spirit.events.SceneEvent;
import spirit.core.Scene;

class PreLoad extends Scene {

  public override function init() {
    assets.addSpriteSheet('sprites', 'assets/spritesheets/sprites.png', 'assets/spritesheets/sprites.json');
    assets.addBitmapFont('16px', 'assets/fonts/pixel16.png', 'assets/fonts/pixel16.fnt');
    assets.addBitmapFont('20px', 'assets/fonts/pixel20.png', 'assets/fonts/pixel20.fnt');
    assets.addBitmapFont('32px', 'assets/fonts/pixel32.png', 'assets/fonts/pixel32.fnt');

    events.emit(SceneEvent.get(SceneEvent.REPLACE, MenuScene));
  }
}