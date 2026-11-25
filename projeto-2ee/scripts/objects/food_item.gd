class_name FoodItem
extends StaticBody3D

@export var item_name: String = "Tomate"
@export var is_cut: bool = false
@export var is_cooked: bool = false

func interact(player: CharacterBody3D) -> void:
	if player.held_item == null:
		player.hold_item(self)

func set_held(held: bool) -> void:
	var col = get_node_or_null("CollisionShape3D")
	if col:
		col.set_deferred("disabled", held)
	# Ao ser segurado, remove da camada de colisão para não colidir com o próprio jogador nem tampar o raycast
	collision_layer = 0 if held else 1
	collision_mask = 0 if held else 1

func cut() -> void:
	if not is_cut:
		is_cut = true
		scale = Vector3(1.0, 0.4, 1.0)

func cook() -> void:
	if not is_cooked:
		is_cooked = true
		var mesh: MeshInstance3D = get_node_or_null("MeshInstance3D")
		if mesh and mesh.material_override:
			var mat = mesh.material_override.duplicate()
			mat.albedo_color = Color(0.4, 0.2, 0.08)
			mesh.material_override = mat
