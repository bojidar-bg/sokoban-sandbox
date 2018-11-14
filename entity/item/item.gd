extends "res://entity/entity.gd"

export(String, FILE, "*.tscn,*.scn") var item_scene

func move(offset, strength = 0, flags = MOVE_DEFAULT):
	if flags & MOVE_INTERACT:
		return strength
	return .move(offset, strength, flags & (~MOVE_INTERACT))

func move_into(entity, offset):
	get_parent().remove_child(self)
	entity.replace_item(load(item_scene).instance())
	entity.move(-offset, 0, MOVE_SELF)
	queue_free()