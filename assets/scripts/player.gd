extends CharacterBody2D
class_name Player

const SPEED = 15000.0

@onready var sprite = $AnimatedSprite2D

var bullet_scene: PackedScene = preload("res://assets/scenes/BasicBullet.tscn")
var health
var immunity_time = 0.75
var immune = false
var curr_immunity_time = 0
var weap = 0
var fire_delay_max = 0.1
var fire_delay
var machinegun_bullets
var shotgun_bullets

func _ready() -> void:
	fire_delay = fire_delay_max
	health = Global.player_health
	shotgun_bullets = Global.shotgun_bullets
	machinegun_bullets = Global.machinegun_bullets

func _physics_process(delta: float) -> void:
	if Engine.time_scale > 0:
		if weap == 0 or weap == 1:
			if Input.is_action_just_pressed("attack"):
				attack()
		if weap == 2:
			fire_delay -= delta
			if Input.is_action_pressed("attack") and fire_delay <= 0:
				attack()
				fire_delay = fire_delay_max * (randf()/2 + 0.5)
			
		var dir_left_right := Input.get_axis("left", "right")
		velocity.x = dir_left_right * SPEED * delta
			
		var dir_up_down := Input.get_axis("up", "down")
		velocity.y = dir_up_down * SPEED * delta
		
		if Input.is_action_pressed("run"):
			velocity.x *= 1.5
			velocity.y *= 1.5
			
		if Input.is_action_just_pressed("weap_next"):
			weap += 1
			if weap == 3:
				weap = 0
			
		if Input.is_action_just_pressed("weap_prev"):
			weap -= 1
			if weap == -1:
				weap = 2
			
			
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
	if weap == 1 and shotgun_bullets <= 0:
		return
	if weap == 2 and machinegun_bullets <= 0:
		return
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $CollisionShape2D.global_position
	bullet.set_target(get_viewport().get_mouse_position())
	get_parent().add_child(bullet)
	if weap == 2:
		machinegun_bullets -= 1
	if weap == 1:
		shotgun_bullets -= 1
		var bullet2 = bullet_scene.instantiate()
		bullet2.global_position = $CollisionShape2D.global_position
		bullet2.direction = (bullet.direction+Vector2(0.15,0.15)).normalized()
		get_parent().add_child(bullet2)
		var bullet3 = bullet_scene.instantiate()
		bullet3.global_position = $CollisionShape2D.global_position
		bullet3.direction = (bullet.direction-Vector2(0.15,0.15)).normalized()
		get_parent().add_child(bullet3)
	

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
	
