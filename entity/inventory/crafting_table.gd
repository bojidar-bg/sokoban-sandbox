extends "res://entity/inventory/inventory_entity.gd"

onready var result_inventory = $result_inventory
var pending_entity = null

func move(offset, strength = 0, flags = MOVE_DEFAULT):
	if flags & MOVE_INTERACT:
		_update_pending()
		if pending_entity != null:
			for i in range(inventory.rect.position.y, inventory.rect.end.y + 1):
				for j in range(inventory.rect.position.x, inventory.rect.end.x + 1):
					var entity = inventory.get_entity_at_position(Vector2(j, i))
					if entity != null:
						entity.free()
			
			var leftover_strength = pending_entity.move(offset, strength, flags & (~MOVE_INTERACT))
			
			if leftover_strength < 0:
				result_inventory.remove_child(pending_entity)
				inventory.add_child(pending_entity)
				inventory.update_entity_position(pending_entity, pending_entity.get_grid_position(), offset)
				pending_entity = null
				return strength
			else:
				strength = leftover_strength
				pending_entity = null
		return -INF
	return .move(offset, strength, flags & (~MOVE_INTERACT))

func update_inside_camera_view():
	result_inventory.visible = false
	.update_inside_camera_view()

func update_outside_camera_view():
	if Player.get_input_movement_flags() & MOVE_INTERACT and should_show_inventory():
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
	
	for i in range(inventory.rect.position.y, inventory.rect.end.y + 1):
		for j in range(inventory.rect.position.x, inventory.rect.end.x + 1):
			var entity = inventory.get_entity_at_position(Vector2(j, i))
			if entity != null:
				cols[i] = true
				rows[j] = true
	
	var previous_i = null
	for i in range(inventory.rect.position.y, inventory.rect.end.y + 1):
		if cols.has(i):
			if previous_i != null:
				for x in range(previous_i, i):
					cols[x] = true
			previous_i = i
	var previous_j = null
	for j in range(inventory.rect.position.x, inventory.rect.end.x + 1):
		if rows.has(j):
			if previous_j != null:
				for x in range(previous_j, j):
					rows[x] = true
			previous_j = j
	
	var recipe_string = ""
	for i in range(inventory.rect.position.y, inventory.rect.end.y + 1): if cols.has(i):
		if recipe_string != "":
			recipe_string += " |"
		for j in range(inventory.rect.position.x, inventory.rect.end.y + 1): if rows.has(j):
			if recipe_string != "":
				recipe_string += " "
			var entity = inventory.get_entity_at_position(Vector2(j, i))
			recipe_string += entity.get_resource_name() if entity != null else "_"
	
	var recipes = {
		"stone stone | stone stone": "res://entity/inventory/chest.tscn",
		"log log": "res://entity/inventory/crafting_table.tscn",
		"log | log": "res://entity/inventory/crafting_table.tscn",
	}
	
	return recipes[recipe_string] if recipe_string in recipes else ""
