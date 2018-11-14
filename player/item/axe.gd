extends "item.gd"

func pre_move(entity, offset, strength, flags):
	if flags & entity.MOVE_SELF and flags & entity.MOVE_INTERACT:
		var next_entity = entity.get_parent().get_entity_at_position(entity.get_grid_position() + offset)
		if next_entity != null and next_entity.has_method("cut_down"):
			next_entity.cut_down(offset)
	return strength
