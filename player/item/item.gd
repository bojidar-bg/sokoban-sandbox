extends Node2D

func _enter_tree():
	get_parent().get_parent().register_item(self)

func _exit_tree():
	get_parent().get_parent().unregister_item(self)

func pre_move(entity, offset, strength, flags):
	return strength

func post_move(entity, offset, strength, flags):
	return strength
