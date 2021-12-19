package systems;

import components.Door;
import spirit.events.EntityEvent;
import spirit.physics.simple.Body;
import spirit.core.Entity;
import spirit.systems.SimplePhysicsSystem;
import spirit.core.System;

class DoorSystem extends System {

  var doors: Array<Entity> = [];

  public function init(): DoorSystem {
    var physics = getSystem(SimplePhysicsSystem);
    
    physics.addInteractionListener(TRIGGER_START, 'red_button', 'player', unlockRed);
    physics.addInteractionListener(TRIGGER_START, 'green_button', 'player', unlockGreen);
    physics.addInteractionListener(TRIGGER_START, 'blue_button', 'player', unlockBlue);

    return this;
  }

  override function entityChange(event: EntityEvent) {
    if (event.type == EntityEvent.ADD_COMPONENT && event.componentType == Door) {
      doors.push(event.entity);
    }
  }

  function unlockRed(a: Body, b: Body) {
    for (door in doors) {
      if (door.getComponent(Door).color == RED) {
        door.active = false;
      }
    }
  }

  function unlockGreen(a: Body, b: Body) {
    for (door in doors) {
      if (door.getComponent(Door).color == GREEN) {
        door.active = false;
      }
    }
  }

  function unlockBlue(a: Body, b: Body) {
    for (door in doors) {
      if (door.getComponent(Door).color == BLUE) {
        door.active = false;
      }
    }
  }
}