class_name Counter
extends StaticBody3D

@onready var hold_point: Marker3D = $HoldPoint
var current_item: Node3D = null

func interact(player: CharacterBody3D) -> void:
	if player.held_item and current_item == null:
		place_item(player.drop_item())
	elif current_item and player.held_item == null:
		player.hold_item(take_item())

func place_item(item: Node3D) -> void:
	current_item = item
	if item.has_method("set_held"):
		item.set_held(true)
	if item.get_parent():
		item.get_parent().remove_child(item)
	hold_point.add_child(item)
	item.position = Vector3.ZERO
	item.rotation = Vector3.ZERO

func take_item() -> Node3D:
	var item = current_item
	current_item = null
	return item
