extends "res://entity/entity.gd"

export var strength = 2

func _ready():
	movement_time /= 2
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		move(Vector2(1, 0), strength)
	if Input.is_action_pressed("move_left"):
		move(Vector2(-1, 0), strength)
	if Input.is_action_pressed("move_down"):
		move(Vector2(0, 1), strength)
	if Input.is_action_pressed("move_up"):
		move(Vector2(0, -1), strength)
