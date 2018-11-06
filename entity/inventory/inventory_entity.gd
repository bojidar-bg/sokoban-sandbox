extends "res://entity/entity.gd"

onready var inventory = $inventory
onready var display_frame = $display_frame
var is_camera_inside = false
var internal_mass = 0

func _ready():
	pass

func get_mass():
	return mass + inventory.get_total_mass()

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
	return .move(offset, strength, flags & (~MOVE_ENTER))

func move_into(entity, offset):
	var camera = _get_active_camera()
	if camera and entity.is_a_parent_of(camera):
		is_camera_inside = true
	
	if entity.is_inside_tree():
		entity.get_parent().remove_child(entity)
	
	inventory.add_child(entity)
	
	entity.position = (inventory.get_inside_position(offset) - offset) * GRID_SIZE
	entity.move_nocheck(offset)

func move_out(entity, offset):
	var camera = _get_active_camera()
	if camera and entity.is_a_parent_of(camera):
		is_camera_inside = false
	
	if entity.is_inside_tree():
		entity.get_parent().remove_child(entity)
	
	get_parent().add_child(entity)
	entity.position = position
	entity.move_nocheck(offset)

func _process(delta):
	if is_camera_inside:
		update_inside_camera_view()
	else:
		call_deferred("update_outside_camera_view")

func update_inside_camera_view():
	var camera_global_position = _get_active_camera().get_global_position()
	display_frame.visible = false
	inventory.visible = true
	$moving.z_index = 2
	inventory.position = inventory.global_position - camera_global_position

func should_show_inventory():
	var camera_global_position = _get_active_camera().get_global_position()
	var offset = ((global_position - camera_global_position) / GRID_SIZE).round()
	return (
		get_parent() == _get_active_camera().get_node("../../..") # HAACK
		and offset.length_squared() < 2
		and not Input.is_action_pressed("mod_push")
	)
	

func update_outside_camera_view():
	var camera_global_position = _get_active_camera().get_global_position()
	var offset = ((global_position - camera_global_position) / GRID_SIZE).round()
	var inside = inventory.get_inside_position(offset)
	var show_inventory = should_show_inventory()
	
	display_frame.visible = show_inventory
	display_frame.rotation = offset.angle() - PI / 2
	$moving.z_index = 2 if show_inventory else 0
	
	inventory.visible = show_inventory
	inventory.position = global_position - camera_global_position - inside * GRID_SIZE

func _get_active_camera():
	for camera in get_tree().get_nodes_in_group("__cameras_%d" % get_viewport().get_viewport_rid().get_id()):
		if camera.current:
			return camera