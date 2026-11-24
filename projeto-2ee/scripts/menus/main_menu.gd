extends Control
func _ready() -> void:
	$HBoxContainer/Iniciar.grab_focus()
	$Credits.hide()
	$Opcoes.hide()
	$Recordes.hide()

func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

func _on_opções_pressed() -> void:
	$Opcoes.show()
	$HBoxContainer.hide()
	$Opcoes/VBoxContainer/Voltar.grab_focus()

func _on_recordes_pressed() -> void:
	$Recordes.show()
	$HBoxContainer.hide()
	$Recordes/VBoxContainer/Voltar.grab_focus()

func _on_sair_pressed() -> void:
	get_tree().quit()

func _on_créditos_pressed() -> void:
	$Credits.show()
	$HBoxContainer.hide()
	$Credits/VBoxContainer/Voltar.grab_focus()
	
func _on_voltar_pressed() -> void:
	$Credits.hide()
	$Opcoes.hide()
	$Recordes.hide()
	$HBoxContainer.show()
	$HBoxContainer/Iniciar.grab_focus()
