extends CharacterBody2D
class_name Octopus

const SPEED = 10000.0

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]


func _physics_process(delta: float) -> void:
	velocity = SPEED * delta * (player.global_position - $CollisionShape2D.global_position).normalized()

	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is BasicBullet:
		area.queue_free()
		queue_free()
