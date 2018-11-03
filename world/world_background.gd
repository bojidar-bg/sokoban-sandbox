extends TextureRect

const GRID_SIZE = Vector2(20, 20)

func _process(delta):
	rect_size = get_viewport_rect().size + GRID_SIZE * 2
	rect_position = - get_viewport().canvas_transform.origin.snapped(GRID_SIZE) - GRID_SIZE * 0.5
