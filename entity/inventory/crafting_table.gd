extends "res://entity/inventory/inventory_entity.gd"

onready var result_inventory = $result_inventory
var pending_entity = null

func move(offset, strength = 0, flags = MOVE_DEFAULT):
	if flags & MOVE_INTERACT:
		_update_pending()
		if pending_entity != null:
			for i in range(3):
				for j in range(3):
					var entity = inventory.get_entity_at_position(Vector2(j - 1, i - 1))
					if entity != null:
						entity.free()
			var put_inside = true
			
			if flags & MOVE_PUSH:
				put_inside = not pending_entity.move(offset, strength, MOVE_PUSH)
			
			if put_inside:
				result_inventory.remove_child(pending_entity)
				inventory.add_child(pending_entity)
				inventory.update_entity_position(pending_entity, pending_entity.get_grid_position(), offset)
				pending_entity = null
				return true
			else:
				pending_entity = null
		return false
	return .move(offset, strength, flags & (~MOVE_INTERACT))

func update_inside_camera_view():
	result_inventory.visible = false
	.update_inside_camera_view()

func update_outside_camera_view():
	if Input.is_action_pressed("mod_interact") and should_show_inventory():
		_update_pending()
		display_frame.visible = false
		inventory.visible = false
		result_inventory.visible = true
		$moving.z_index = 0
	else:
		result_inventory.visible = false
		.update_outside_camera_view()

func _update_pending():
	var wanted = _match_recipe()
	var current = pending_entity.get_filename() if pending_entity else ""
	if wanted != current:
		if pending_entity != null:
			pending_entity.free()
			pending_entity = null
		
		if wanted != "":
			pending_entity = load(wanted).instance()
			pending_entity.position = Vector2(0, 0)
			result_inventory.add_child(pending_entity)

func _match_recipe():
	var rows = {}
	var cols = {}
	
	for i in range(3):
		for j in range(3):
			var entity = inventory.get_entity_at_position(Vector2(j - 1, i - 1))
			if entity != null:
				cols[i] = true
				rows[j] = true
	
	if cols.has(0) and cols.has(2):
		cols[1] = true
	if rows.has(0) and rows.has(2):
		rows[1] = true
	
	var recipe_string = ""
	for i in range(3): if cols.has(i):
		if recipe_string != "":
			recipe_string += " |"
		for j in range(3): if rows.has(j):
			if recipe_string != "":
				recipe_string += " "
			var entity = inventory.get_entity_at_position(Vector2(j - 1, i - 1))
			recipe_string += entity.get_resource_name() if entity != null else "_"
	
	var recipes = {
		"stone stone | stone stone": "res://entity/inventory/chest.tscn",
		"log log": "res://entity/inventory/crafting_table.tscn",
		"log | log": "res://entity/inventory/crafting_table.tscn",
	}
	
	return recipes[recipe_string] if recipe_string in recipes else ""
