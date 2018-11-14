extends Node2D

export(String, FILE, "*.tscn,*.scn") var entity_scene

func pre_move(entity, offset, strength, flags):
	return strength

func post_move(entity, offset, strength, flags):
	return strength

func drop(entity):
	var instance = load(entity_scene).instance()
	instance.position = entity.position
	entity.get_parent().add_child(instance)
