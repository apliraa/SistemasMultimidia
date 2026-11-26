class_name GameManager
extends Node

@export var customer_scene: PackedScene = preload("res://scenes/actors/customer.tscn")
@export var spawn_interval: float = 10.0
@export var spawn_offset_z: float = 10.0
@export var food_order_list: Array[String] = ["normal", "cortada", "cozida"]

const MAX_PER_COLUMN: int = 5

var active_customers: Array[Customer] = []
var column_queues = [[], [], []]
var customer_to_column: Dictionary = {}

var spot_base_positions: Array[Vector3] = [
	Vector3(4.5, 1.5, -2.5),
	Vector3(6.0, 1.5, -2.5),
	Vector3(7.5, 1.5, -2.5)
]

var spawn_timer: float = 0.0
var current_order_index: int = 0

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_customer()

func get_available_column() -> int:
	var min_len = column_queues[0].size()
	var min_idx = 0
	for i in range(1, column_queues.size()):
		if column_queues[i].size() < min_len:
			min_len = column_queues[i].size()
			min_idx = i
	if min_len >= MAX_PER_COLUMN:
		return -1
	return min_idx

func get_spot_position(col: int, row: int) -> Vector3:
	var base_pos = spot_base_positions[col]
	return Vector3(base_pos.x, base_pos.y, base_pos.z - (row * 1.5))

func spawn_customer() -> void:
	var column = get_available_column()
	if column == -1:
		return
	var row = column_queues[column].size()
	var target_pos = get_spot_position(column, row)
	var spawn_pos = Vector3(target_pos.x, target_pos.y, target_pos.z - spawn_offset_z)

	var customer: Customer = customer_scene.instantiate()
	var dish = food_order_list[current_order_index]
	current_order_index = (current_order_index + 1) % food_order_list.size()
	customer.dish_type = dish

	column_queues[column].append(customer)
	customer_to_column[customer] = column
	active_customers.append(customer)

	get_parent().add_child(customer)
	customer.global_position = spawn_pos
	customer.move_to(target_pos)

	customer.served.connect(_on_customer_served.bind(customer))
	customer.tree_exiting.connect(_on_customer_exiting.bind(customer))

func _remove_customer(customer: Customer) -> void:
	if not active_customers.has(customer):
		return
	active_customers.erase(customer)
	if not customer_to_column.has(customer):
		return
	var col = customer_to_column[customer]
	customer_to_column.erase(customer)
	var idx = column_queues[col].find(customer)
	if idx != -1:
		column_queues[col].remove_at(idx)
		_update_column_positions(col)

func _update_column_positions(col: int) -> void:
	for i in range(column_queues[col].size()):
		var cust = column_queues[col][i]
		var new_target = get_spot_position(col, i)
		cust.move_to(new_target)

func _on_customer_served(customer: Customer) -> void:
	_remove_customer(customer)

func _on_customer_exiting(customer: Customer) -> void:
	_remove_customer(customer)
