extends "res://grid.gd"

export var rect = Rect2(-1, -1, 2, 2)

func _ready():
	$background/texture_rect.rect_position = (rect.position - Vector2(0.5, 0.5)) * GRID_SIZE - Vector2(1, 1)
	$background/texture_rect.rect_size = (rect.size + Vector2(1, 1)) * GRID_SIZE + Vector2(2, 2)

func update_entity_position(entity, pos, offset):
	var outside_offset = get_outside_offset(pos)
	
	if outside_offset != Vector2():
		get_parent().move_out(entity, offset)
	else:
		.update_entity_position(entity, pos, offset)

func get_entity_at_position(pos):
	var offset = get_outside_offset(pos)
	
	if offset != Vector2():
		return get_parent().get_parent().get_entity_at_position(get_parent().get_grid_position() + offset)
	else:
		return .get_entity_at_position(pos)

func get_outside_offset(pos):
	var offset = Vector2()
	if pos.x >= rect.end.x:
		offset.x += pos.x - rect.end.x
	if pos.x < rect.position.x:
		offset.x += pos.x - rect.position.x
	if pos.y >= rect.end.y:
		offset.y += pos.y - rect.end.y
	if pos.y < rect.position.y:
		offset.y += pos.y - rect.position.y
	return offset

func get_inside_position(offset):
	var pos = offset
	if offset.x < 0:
		pos.x += rect.end.x + 1
	elif offset.x > 0:
		pos.x += rect.position.x - 1
	
	if offset.y < 0:
		pos.y += rect.end.y + 1
	elif offset.y > 0:
		pos.y += rect.position.y - 1
	return pos

func get_total_mass():
	var mass = 0
	for entity in entities:
		mass += entity.get_mass()
	return mass

func allows_subgrids():
	return false