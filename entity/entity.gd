extends Node2D

const GRID_SIZE = Vector2(20, 20)

enum {
	MOVE_PUSH = 1 << 0
	MOVE_ENTER = 1 << 1
	MOVE_INTERACT = 1 << 2
}
const MOVE_DEFAULT = MOVE_PUSH | MOVE_ENTER

var _moving = false
var movement_time = 0.2 # s
onready var tween = $tween
export var mass = 1

func _ready():
	get_parent().update_entity_position(self, get_grid_position(), Vector2())

func _exit_tree():
	get_parent().remove_entity(self)

func get_resource_name():
	return get_filename().get_file().get_basename()

func get_grid_position():
	return (position / GRID_SIZE).floor()

func get_mass():
	return mass

func move(offset, strength = mass, flags = MOVE_DEFAULT): # -> bool (could move)
	strength -= get_mass()
	if offset.length_squared() < 0.01:
		return true
	
	if _moving or strength < 0:
		return false
	
	var to_push = get_parent().get_entity_at_position(get_grid_position() + offset)
	if to_push != null:
		if not (bool(flags & MOVE_PUSH) and to_push.move(offset, strength, flags)):
			return false # Likely not enough strength
	
	position += offset * GRID_SIZE
	get_parent().update_entity_position(self, get_grid_position(), offset)
	
	animate_move(offset)
	
	return true

func animate_move(offset):
	if _moving:
		return
	_moving = true
	
	tween.remove_all()
	$moving.position = -offset * GRID_SIZE
	tween.interpolate_property(
		$moving, "position",
		$moving.position, Vector2(),
		movement_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	tween.remove_all()
	
	_moving = false