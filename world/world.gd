extends Node2D

var entities = {} # Entity -> Vector2
var positions = {} # Vector2 -> Entity

func _ready():
	OS.window_fullscreen = true

func update_entity_position(entity, pos):
	if entity in entities:
		positions.erase(entities[entity])
	entities[entity] = pos
	assert(not (pos in positions))
	positions[pos] = entity

func get_entity_at_position(pos):
	if pos in positions:
		return positions[pos]
	else:
		return null
