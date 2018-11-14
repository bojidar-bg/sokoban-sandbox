extends "res://grid.gd"


func _ready():
#	OS.window_fullscreen = true
#	OS.window_borderless = true
#	OS.window_size = OS.get_screen_size()
#	OS.window_position = OS.get_screen_position()
	randomize()
	var options = {
		tree = 0.25,
		tree_group = 0.2,
		stone = 0.1,
		rock_group = 0.1,
	}
	var generation_range = 100
	var total_weight = 0
	for option in options:
		total_weight += options[option]
	
	var tree = load("res://entity/resource/tree.tscn")
	var rock = load("res://entity/resource/stone.tscn")
	var things = {}
	
	for i in generation_range * generation_range * 0.06:
		var pos = (Vector2(randf() - 0.5, randf() - 0.5) * generation_range).round()
		var selected = randf() * total_weight
		var selected_option = ""
		for option in options:
			selected -= options[option]
			if selected <= 0:
				selected_option = option
				break
		
		match selected_option:
			"tree":
				things[pos] = tree
			"tree_group":
				for i in 5:
					var pos2 = (Vector2(randf() - 0.5, randf() - 0.5) * 2).round()
					things[pos + pos2] = tree
			"rock":
				things[pos] = rock
			"rock_group":
				for i in 16:
					var pos2 = (Vector2(randf() - 0.5, randf() - 0.5) * 4).round()
					things[pos + pos2] = rock
	
	things[Vector2(0, 0)] = load("res://player/player.tscn")
	things.erase(Vector2(0, 1))
	things.erase(Vector2(0, -1))
	things.erase(Vector2(1, 0))
	things.erase(Vector2(-1, 0))
	things[Vector2(2, 0)] = load("res://entity/inventory/crafting_table.tscn")
	things[Vector2(-1, 0)] = load("res://entity/item/axe.tscn")
	
	for pos in things:
		var thing = things[pos].instance()
		thing.position = pos * GRID_SIZE
		add_child(thing)
	
	print(get_child_count())
	
	pass

