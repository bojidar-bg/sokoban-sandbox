extends "res://entity/entity.gd"

func cut_down(offset):
	for i in range(randi() % 3 + 3):
		if get_parent().get_entity_at_position(get_grid_position() + offset * i) == null:
			var thing = preload("res://entity/resource/log.tscn").instance()
			thing.position = position + offset * GRID_SIZE * i
			get_parent().add_child(thing)
	get_parent().remove_child(self)
	queue_free()
