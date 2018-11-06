extends "res://entity/entity.gd"

export var strength = 2
var last_horizontal = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	if not _moving:
		var flags = 0
		if Input.is_action_pressed("mod_push"):
			flags = MOVE_PUSH
		else:
			flags = MOVE_DEFAULT
		if Input.is_action_pressed("mod_interact"):
			flags |= MOVE_INTERACT
		
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
		
		move(direction, strength + mass, flags)
		$moving/overlay/label.text = str(get_grid_position())
