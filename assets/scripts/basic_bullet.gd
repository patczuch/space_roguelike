extends Area2D
class_name BasicBullet

const SPEED: float = 1000.0
var direction: Vector2 = Vector2(0,0)

func _physics_process(delta: float) -> void:
	position += SPEED * delta * direction
	pass
	
func set_target(mouse_pos: Vector2) -> void:
	direction = (mouse_pos - $CollisionShape2D.global_position).normalized()
