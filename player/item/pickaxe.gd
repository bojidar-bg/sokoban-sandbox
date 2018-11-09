extends "res://player/item/item.gd"

func post_move(entity, offset, strength, flags):
	if flags & entity.MOVE_SELF and flags & entity.MOVE_INTERACT:
		var previous_entity = entity.get_parent().get_entity_at_position(entity.get_grid_position() - offset * 2)
		if previous_entity != null and previous_entity != entity:
			var leftover_strength = strength - previous_entity.get_mass()
			if leftover_strength >= 0:
				strength = leftover_strength
				previous_entity.move(offset, strength, entity.MOVE_SELF)
	return .pre_move(entity, offset, strength, flags)
