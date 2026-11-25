class_name Crate
extends StaticBody3D

@export var item_scene: PackedScene

func interact(player: CharacterBody3D) -> void:
	if player.held_item == null and item_scene:
		var item = item_scene.instantiate()
		player.hold_item(item)
