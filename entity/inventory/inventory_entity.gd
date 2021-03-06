extends "res://entity/entity.gd"

const Player = preload("res://player/player.gd")
onready var inventory = $inventory
onready var display_frame = $display_frame
var is_camera_inside = false
var internal_mass = 0

func _ready():
	pass

func get_mass():
	return mass + inventory.get_total_mass()

func move(offset, strength = 0, flags = MOVE_DEFAULT):
	if flags & MOVE_ENTER and get_parent().allows_subgrids():
		var next_entity = inventory.get_entity_at_position(inventory.get_inside_position(offset))
		if next_entity != null:
			strength = next_entity.move(offset, strength, flags)
			return strength
		else:
			return strength
	return .move(offset, strength, flags & (~MOVE_ENTER))

func move_into(entity, offset):
	var camera = _get_active_camera()
	if camera and entity.is_a_parent_of(camera):
		is_camera_inside = true
	
	if entity.is_inside_tree():
		entity.get_parent().remove_child(entity)
	
	entity.position = (inventory.get_inside_position(offset)) * GRID_SIZE
	inventory.add_child(entity)
	inventory.update_entity_position(entity, entity.get_grid_position(), offset)
	entity.animate_move(offset + offset.normalized().round())

func move_out(entity, offset):
	var camera = _get_active_camera()
	if camera and entity.is_a_parent_of(camera):
		is_camera_inside = false
		
	if entity.is_inside_tree():
		entity.get_parent().remove_child(entity)
	
	entity.position = position + offset * GRID_SIZE
	get_parent().add_child(entity)
	get_parent().update_entity_position(entity, entity.get_grid_position(), offset)

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
		and get_parent().allows_subgrids()
		and offset.length_squared() < 2
		and Player.get_input_movement_flags() & MOVE_ENTER
	)

func update_outside_camera_view():
	var camera_global_position = _get_active_camera().get_global_position()
	var offset = ((global_position - camera_global_position) / GRID_SIZE)
	var inside = inventory.get_inside_position(offset.normalized().round())
	var show_inventory = should_show_inventory()
	
	display_frame.visible = show_inventory
	display_frame.rotation = round(offset.angle() / (PI / 2)) * PI / 2 - PI / 2
	$moving.z_index = 2 if show_inventory else 0
	
	inventory.visible = show_inventory
	inventory.position = (offset - inside) * GRID_SIZE

func _get_active_camera():
	for camera in get_tree().get_nodes_in_group("__cameras_%d" % get_viewport().get_viewport_rid().get_id()):
		if camera.current:
			return camera