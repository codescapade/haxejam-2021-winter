package components;

import spirit.math.SpMath;
import spirit.math.Vector2;
import spirit.math.Rect;
import spirit.core.Updatable;
import spirit.components.Camera;
import spirit.components.Transform;
import spirit.core.Component;

class CameraFollow extends Component implements Updatable {

  var camera: Camera;

  var transform: Transform;

  var target: Transform;

  var minX: Float;
  var minY: Float;
  var maxX: Float;
  var maxY: Float;

  var speed: Float;

  var currentPos = new Vector2();
  var targetPos = new Vector2();

  public function init(options: CameraFollowOptions): CameraFollow {
    camera = getComponent(Camera);
    transform = getComponent(Transform);
    target = options.target;
    minX = options.minX;
    minY = options.minY;
    maxX = options.maxX;
    maxY = options.maxY;
    speed = options.speed;
    targetPos.set(target.x, target.y);
    currentPos.copyFrom(targetPos);
    transform.x = target.x;
    transform.y = target.y;

    return this;
  }

  public function update(dt: Float) {
    targetPos.set(target.x, target.y);

    Vector2.lerp(currentPos, targetPos, speed * dt, currentPos);

    currentPos.x = SpMath.clamp(currentPos.x, minX + camera.viewWidth * 0.5, maxX - camera.viewWidth * 0.5);
    currentPos.y = SpMath.clamp(currentPos.y, minY + camera.viewHeight * 0.5, maxY - camera.viewHeight * 0.5);
    transform.setPosition(currentPos.x, currentPos.y);
  }

  override function get_requiredComponents():Array<Class<Component>> {
    return [Camera, Transform];
  }
}

typedef CameraFollowOptions = {
  var target: Transform;
  var minX: Float;
  var minY: Float;
  var maxX: Float;
  var maxY: Float; 
  var speed: Float;
}