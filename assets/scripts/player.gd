extends CharacterBody2D
class_name Player

const SPEED = 15000.0

@onready var sprite = $AnimatedSprite2D

var bullet_scene: PackedScene = preload("res://assets/scenes/BasicBullet.tscn")
var health = 3

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("attack"):
		attack()
		
	var dir_left_right := Input.get_axis("left", "right")
	velocity.x = dir_left_right * SPEED * delta
		
	var dir_up_down := Input.get_axis("up", "down")
	velocity.y = dir_up_down * SPEED * delta
		
		
	if dir_left_right or dir_up_down:
		sprite.play("walk")
	else:
		sprite.play("idle")
		
	if dir_left_right:
		if dir_left_right > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
			
	#print(global_positiona)

	move_and_slide()
	
func attack() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $CollisionShape2D.global_position
	bullet.set_target(get_viewport().get_mouse_position())
	get_parent().add_child(bullet)
	
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() and area.get_parent().is_in_group("enemies") or area.get_parent() is Spikes:
		health -= 1
	if health <= 0:
		queue_free()
