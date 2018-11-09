extends "res://entity/entity.gd"

export var strength = 2
var last_horizontal = false
var items = {}

func _physics_process(delta):
	if not _moving:
		var flags = get_input_movement_flags()
		
		var direction = Vector2(0, 0)
		
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		
		if direction.x != 0 and direction.y != 0:
			if last_horizontal:
				direction.y = 0
			else:
				direction.x = 0
			last_horizontal = not last_horizontal
		
		move(direction, strength, flags | MOVE_SELF)
		$moving/overlay/label.text = str(get_grid_position())

func move(offset, strength = 0, flags = MOVE_DEFAULT):
	for item in items:
		strength = item.pre_move(self, offset, strength, flags)
		if strength < 0: return strength
	
	strength = .move(offset, strength, flags)
	if strength < 0: return strength
	
	for item in items:
		strength = item.post_move(self, offset, strength, flags)
		if strength < 0: return strength
	
	return strength

func register_item(item):
	items[item] = true

func unregister_item(item):
	items.erase(item)

static func get_input_movement_flags():
	if Input.is_action_pressed("mod_push") and Input.is_action_pressed("mod_interact"):
		return MOVE_INTERACT
	elif Input.is_action_pressed("mod_push"):
		return MOVE_PUSH
	elif Input.is_action_pressed("mod_interact"):
		return MOVE_DEFAULT | MOVE_INTERACT
	else:
		return MOVE_DEFAULT
