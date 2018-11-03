extends "res://entity/entity.gd"

export var strength = 2

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
		
		if Input.is_action_pressed("move_right"):
			move(Vector2(1, 0), strength + mass, flags)
		if Input.is_action_pressed("move_left"):
			move(Vector2(-1, 0), strength + mass, flags)
		if Input.is_action_pressed("move_down"):
			move(Vector2(0, 1), strength + mass, flags)
		if Input.is_action_pressed("move_up"):
			move(Vector2(0, -1), strength + mass, flags)
		$moving/overlay/label.text = str(get_grid_position())
