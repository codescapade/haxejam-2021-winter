package components;

import spirit.core.Component;

class Door extends Component {

  public var color(default, null): DoorColor;

  public function init(options: DoorOptions): Door {
    color = options.color;

    return this;
  }
}

typedef DoorOptions = {
  var color: DoorColor;
}