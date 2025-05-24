extends Node2D

var amplitude := 7.0  
var speed := 0.7      
var base_position
var start_offset

func _ready() -> void:
	base_position = global_position
	start_offset = randf() * 5


func _process(delta: float) -> void:
	var offset = sin(Time.get_ticks_msec() / 1000.0 * speed * TAU + start_offset) * amplitude
	global_position.y = base_position.y + offset
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().shotgun_bullets += 15
		queue_free()
