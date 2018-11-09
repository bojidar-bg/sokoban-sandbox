extends Node2D

const GRID_SIZE = Vector2(20, 20)

var entities = {} # Entity -> Vector2
var positions = {} # Vector2 -> Entity

func update_entity_position(entity, pos, offset):
	if entity in entities:
		positions.erase(entities[entity])
	
	if pos in positions:
		if entity != positions[pos]:
			assert(allows_subgrids())
			positions[pos].move_into(entity, offset)
	else:
		entities[entity] = pos
		positions[pos] = entity

func get_entity_at_position(pos):
	if pos in positions:
		return positions[pos]
	else:
		return null

func remove_entity(entity):
	if entity in entities:
		positions.erase(entities[entity])
		entities.erase(entity)

func allows_subgrids():
	return true
