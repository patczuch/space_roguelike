extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		get_parent().get_parent().change_floor = true
