extends CharacterBody2D
class_name Octopus

const SPEED = 10000.0

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]

var health
var max_health = 20
var start_delay = 0.5
var delay


func _physics_process(delta: float) -> void:
	if delay > 0:
		scale = Vector2(scale.x + delta/start_delay, scale.x + delta/start_delay)
		delay -= delta
	if delay <= 0:
		scale = Vector2(1,1)
		if player:
			velocity = SPEED * delta * (player.global_position - $CollisionShape2D.global_position).normalized()
		else:
			velocity = Vector2(0, 0)

	move_and_slide()
	
	
func _process(delta: float) -> void:
	if health <= 0:
		get_tree().root.get_node("RoomSpawner").get_node("Hud").add_points(100)
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is BasicBullet:
		area.queue_free()
		health -= area.damage


func _on_ready() -> void:
	delay = start_delay
	health = max_health
	scale = Vector2(0,0)
