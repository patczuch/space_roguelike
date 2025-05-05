extends Node2D

var pressed_texture = ImageTexture.create_from_image(Image.load_from_file("res://assets/textures/button_pressed.png"))

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		$Sprite2D.texture = pressed_texture
		if is_in_group("buttons"):
			get_tree().root.get_node("RoomSpawner").get_node("Hud").add_points(20)
		remove_from_group("buttons")  
