extends Node2D

var _moving = false
var movement_time = 0.3 # s
const GRID_SIZE = Vector2(20, 20)
onready var tween = $tween
onready var world = $".."
var mass = 1

func _ready():
	world.update_entity_position(self, get_grid_position())

func get_grid_position():
	return (position / GRID_SIZE).floor()

func move(offset, strength = 0): # -> bool (could move)
	if offset.length_squared() < 0.01:
		return true
	
	if _moving or strength < 0:
		return false
	
	var to_push = world.get_entity_at_position(get_grid_position() + offset)
	if to_push != null:
		if not to_push.move(offset, strength - mass):
			return false # Not enough strength, probably
	
	_moving = true
	
	position += offset * GRID_SIZE
	
	world.update_entity_position(self, get_grid_position())
	
	tween.remove_all()
	$moving.position = -offset * GRID_SIZE
	tween.interpolate_property(
		$moving, "position",
		-offset * GRID_SIZE, Vector2(),
		movement_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	_moving = false
