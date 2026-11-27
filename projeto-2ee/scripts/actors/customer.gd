class_name Customer
extends StaticBody3D

signal served(customer: Customer)

@export var dish_type: String = "normal" # "normal", "cortada", "cozida"

@onready var label: Label3D = $Label3D

func _ready() -> void:
	update_label()

func set_dish_type(new_dish: String) -> void:
	dish_type = new_dish
	update_label()

func update_label() -> void:
	if label:
		label.text = dish_type

func interact(player: CharacterBody3D) -> void:
	_try_serve(player)

func interact_action(player: CharacterBody3D) -> void:
	_try_serve(player)

func _try_serve(player: CharacterBody3D) -> void:
	var held = player.held_item
	if held == null:
		return

	if _is_correct_food(held):
		player.drop_item().queue_free()
		served.emit(self)
		queue_free()

func _is_correct_food(food: Node3D) -> bool:
	var is_cut: bool = food.get("is_cut") == true
	var is_cooked: bool = food.get("is_cooked") == true

	match dish_type:
		"normal":
			return not is_cut and not is_cooked
		"cortada":
			return is_cut and not is_cooked
		"cozida":
			return is_cooked
	return false

func move_to(target_pos: Vector3) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, 1.5)
