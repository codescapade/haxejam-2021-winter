
class GameManager {

  public static final instance = new GameManager();


  public final maxLevel = 3;

  public var level(default, null): Int;

  public var levelComplete = false;

  public function new() {
    reset();
  }

  public function nextLevel(): Bool {
    level++;
    return level <= maxLevel;
  }

  public function reset() {
    level = 1;
  }
}