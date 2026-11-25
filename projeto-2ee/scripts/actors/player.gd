extends CharacterBody3D

const SPEED = 5.0

@onready var hold_point: Marker3D = $HoldPoint
@onready var interaction_ray: RayCast3D = $InteractionRay
@onready var interaction_area: Area3D = $InteractionArea

var held_item: Node3D = null
var is_busy: bool = false

#func _ready() -> void:



func _physics_process(delta: float) -> void:
	if is_busy:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		var target_angle = atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, 15.0 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if is_busy:
		return

	if event.is_action_pressed("interact") and not event.is_echo():
		_try_interact()
	elif event.is_action_pressed("action") and not event.is_echo():
		_try_action()

func get_target() -> Node:
	if interaction_ray.is_colliding():
		var col = interaction_ray.get_collider()
		if col != self and col != held_item and col.has_method("interact"):
			return col

#Utiliza a área 3d caso o raycast dê errado
	if interaction_area:
		for body in interaction_area.get_overlapping_bodies():
			if body != self and body != held_item and body.has_method("interact"):
				return body
		for area in interaction_area.get_overlapping_areas():
			if area != self and area != held_item and area.has_method("interact"):
				return area

	return null

func _try_interact() -> void:
	var target = get_target()
	if target:
		target.interact(self)
		return

	if held_item:
		drop_item_in_front()

func _try_action() -> void:
	var target = get_target()
	if target and target.has_method("interact_action"):
		target.interact_action(self)

func hold_item(item: Node3D) -> void:
	held_item = item
	if item.has_method("set_held"):
		item.set_held(true)
	if item.get_parent():
		item.get_parent().remove_child(item)
	hold_point.add_child(item)
	item.position = Vector3.ZERO
	item.rotation = Vector3.ZERO

func drop_item() -> Node3D:
	var item = held_item
	held_item = null
	if item:
		if item.get_parent():
			item.get_parent().remove_child(item)
		if item.has_method("set_held"):
			item.set_held(false)
	return item

func drop_item_in_front() -> void:
	var item = drop_item()
	if item:
		get_tree().current_scene.add_child(item)
		var forward = -global_transform.basis.z.normalized()
		var drop_pos = global_position + forward * 1.2
		drop_pos.y = 0.7 # No chão
		item.global_position = drop_pos
		item.rotation = Vector3.ZERO
