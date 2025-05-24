extends CharacterBody2D
class_name Player

const SPEED = 15000.0

@onready var sprite = $AnimatedSprite2D

var bullet_scene: PackedScene = preload("res://assets/scenes/BasicBullet.tscn")
var health
var immunity_time = 1.0
var immune = false
var curr_immunity_time = 0

func _ready() -> void:
	health = Global.player_health

func _physics_process(delta: float) -> void:
	if Engine.time_scale > 0:

		if Input.is_action_just_pressed("attack"):
			attack()
			
		var dir_left_right := Input.get_axis("left", "right")
		velocity.x = dir_left_right * SPEED * delta
			
		var dir_up_down := Input.get_axis("up", "down")
		velocity.y = dir_up_down * SPEED * delta
		
		if Input.is_action_pressed("run"):
			velocity.x *= 1.5
			velocity.y *= 1.5
			
			
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

		curr_immunity_time += delta
		if immune:
			$AnimatedSprite2D.modulate = Color(1, lerp(0.0, 1.0, curr_immunity_time / immunity_time),lerp(0.0, 1.0, curr_immunity_time / immunity_time), 1)
		else:
			$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
		
	move_and_slide()
	
func attack() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $CollisionShape2D.global_position
	bullet.set_target(get_viewport().get_mouse_position())
	get_parent().add_child(bullet)
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() and area.get_parent().is_in_group("enemies") or area.get_parent() is Spikes:
		if not immune:
			health -= 1
			Global.player_health = health
			curr_immunity_time = 0
			immune = true
			var timer = Timer.new()
			add_child(timer)
			timer.wait_time = immunity_time
			timer.one_shot = true
			timer.start()
			timer.timeout.connect(_on_timer_timeout)
	if health <= 0:
		get_tree().root.get_node("RoomSpawner").get_node("PauseMenu").show_game_over()
		queue_free()
		
func _on_timer_timeout() -> void:
	immune = false
	curr_immunity_time = 0
	
