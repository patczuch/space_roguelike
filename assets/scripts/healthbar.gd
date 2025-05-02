extends Node2D

func _process(delta: float) -> void:
	var health_percent = get_parent().health / get_parent().max_health
	$Bar.scale = Vector2(health_percent * 5, 1)
	$Bar.modulate = Color(lerp(0.0, 1.0, 1 - health_percent), lerp(0.6, 0.0, 1 - health_percent), lerp(0.2, 0.0, 1 - health_percent))
	
