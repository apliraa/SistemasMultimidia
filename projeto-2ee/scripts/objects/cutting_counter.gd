class_name CuttingCounter
extends Counter

@export var cut_time: float = 1.5

func interact_action(player: CharacterBody3D) -> void:
	if current_item and current_item.has_method("cut") and not current_item.is_cut:
		player.is_busy = true
		await get_tree().create_timer(cut_time).timeout
		player.is_busy = false
		if current_item and current_item.has_method("cut"):
			current_item.cut()
