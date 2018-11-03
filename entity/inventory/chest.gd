extends "res://entity/entity.gd"

onready var inventory = $inventory

func _ready():
	pass

func get_active_camera():
	for camera in get_tree().get_nodes_in_group("__cameras_%d" % get_viewport().get_viewport_rid().get_id()):
		if camera.current:
			return camera

func move(offset, strength = 0, flags = MOVE_DEFAULT):
	if flags & MOVE_ENTER:
		var to_push = inventory.get_entity_at_position(inventory.get_inside_position(offset))
		if to_push != null:
			if flags & MOVE_PUSH:
				if to_push.move(offset, strength, flags):
					return true
				# ! no else here
			else:
				return false
		else:
			return true
	return .move(offset, strength, flags)

func move_into(entity, comming_from):
	var offset = entity.get_grid_position() - comming_from
	
	var camera = get_active_camera()
	if camera and entity.is_a_parent_of(camera):
		inventory.visible = true
	
	if entity.is_inside_tree():
		entity.get_parent().remove_child(entity)
	
	inventory.add_child(entity)
	entity.set_grid_position(inventory.get_inside_position(offset))

func move_out(entity, offset):
	var new_position = get_grid_position() + offset
	inventory.remove_entity(entity)
	
	var camera = get_active_camera()
	if camera and entity.is_a_parent_of(camera):
		inventory.visible = false
	
	if entity.is_inside_tree():
		entity.get_parent().remove_child(entity)
	
	get_parent().add_child(entity)
	entity.set_grid_position(new_position)