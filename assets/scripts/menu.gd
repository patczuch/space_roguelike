extends Control


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/RoomSpawner.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
