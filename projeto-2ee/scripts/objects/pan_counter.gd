class_name PanCounter
extends Counter

@export var cook_time: float = 3.0
var is_cooking: bool = false

func interact(player: CharacterBody3D) -> void:
	super.interact(player)
	if current_item and not is_cooking and current_item.has_method("cook") and not current_item.is_cooked:
		_cook()

func _cook() -> void:
	is_cooking = true
	await get_tree().create_timer(cook_time).timeout
	if current_item and current_item.has_method("cook"):
		current_item.cook()
	is_cooking = false
