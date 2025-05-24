extends Node2D
class_name Room

var roomSpawner: RoomSpawner
var exited: bool
var id: int
var roomPosition
var color

var reward_spawned = false
var heart_chance = 0.5
var shotgun_chance = 0.5
var machinegun_chance = 0.3

var open_door_texture = load('res://assets/textures/door.png')
var closed_door_texture = load('res://assets/textures/door_closed.png')
var heart_scene = load("res://assets/scenes/heart.tscn")
var shotgun_scene = load("res://assets/scenes/Shotgun.tscn")
var machinegun_scene = load("res://assets/scenes/Machinegun.tscn")

func load_from_file(text: String):
	var lines = text.split("\n")
	for line in lines:
		var params = line.split(" ")
		var object = load("res://assets/scenes/" + params[0] + ".tscn").instantiate()
		object.global_position = Vector2(float(params[1]), float(params[2]))
		add_child(object)

func is_spawn_area_clear_2d(spawn_position: Vector2, colShape) -> bool:
	var space_state = get_world_2d().direct_space_state
	var transform = Transform2D(0, spawn_position)

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = colShape 
	query.transform = transform
	query.collision_mask = (1 << 0) | (1 << 1)

	var result = space_state.intersect_shape(query, 10)
	#print(result)
	return result.is_empty()		
		
func _process(delta: float):
	var flag = false
	for node in get_children():
		if node.is_in_group("enemies") or node.is_in_group("buttons"):
			if $DoorUp:
				$DoorUp.get_node("Sprite2D").texture = closed_door_texture
				$DoorUp.get_node("CollisionShape2D").disabled = true
			if $DoorDown:
				$DoorDown.get_node("Sprite2D").texture = closed_door_texture
				$DoorDown.get_node("CollisionShape2D").disabled = true
			if $DoorLeft:
				$DoorLeft.get_node("Sprite2D").texture = closed_door_texture
				$DoorLeft.get_node("CollisionShape2D").disabled = true
			if $DoorRight:
				$DoorRight.get_node("Sprite2D").texture = closed_door_texture
				$DoorRight.get_node("CollisionShape2D").disabled = true
			flag = true
	if not flag:
		if $DoorUp:
			$DoorUp.get_node("Sprite2D").texture = open_door_texture
			$DoorUp.get_node("CollisionShape2D").disabled = false
		if $DoorDown:
			$DoorDown.get_node("Sprite2D").texture = open_door_texture
			$DoorDown.get_node("CollisionShape2D").disabled = false
		if $DoorLeft:
			$DoorLeft.get_node("Sprite2D").texture = open_door_texture
			$DoorLeft.get_node("CollisionShape2D").disabled = false
		if $DoorRight:
			$DoorRight.get_node("Sprite2D").texture = open_door_texture
			$DoorRight.get_node("CollisionShape2D").disabled = false
		if not reward_spawned and id >= 0:
			if randf() <= heart_chance:
				var position
				var flag2 = false
				var heartColShape = heart_scene.instantiate().get_node("Area2D").get_node("CollisionShape2D").shape
				for i in range(50):
					position = Vector2(lerp(165, 1120, randf()), lerp(125, 560, randf()))
					if is_spawn_area_clear_2d(position, heartColShape):
						flag2 = true
						break
				if flag2:
					var heart = heart_scene.instantiate()
					heart.global_position = position
					add_child(heart)
			if randf() <= shotgun_chance:
				var position
				var flag2 = false
				var shotgunColShape = shotgun_scene.instantiate().get_node("Area2D").get_node("CollisionShape2D").shape
				for i in range(50):
					position = Vector2(lerp(165, 1120, randf()), lerp(125, 560, randf()))
					if is_spawn_area_clear_2d(position, shotgunColShape):
						flag2 = true
						break
				if flag2:
					var shotgun = shotgun_scene.instantiate()
					shotgun.global_position = position
					add_child(shotgun)
			if randf() <= machinegun_chance:
				var position
				var flag2 = false
				var machinegunColShape = machinegun_scene.instantiate().get_node("Area2D").get_node("CollisionShape2D").shape
				for i in range(50):
					position = Vector2(lerp(165, 1120, randf()), lerp(125, 560, randf()))
					if is_spawn_area_clear_2d(position, machinegunColShape):
						flag2 = true
						break
				if flag2:
					var machinegun = machinegun_scene.instantiate()
					machinegun.global_position = position
					add_child(machinegun)
			reward_spawned = true
			

func set_doors(_doors: Array):
	if not _doors[0]:
		$DoorUp.queue_free()
	if not _doors[1]:
		$DoorDown.queue_free()
	if not _doors[2]:
		$DoorLeft.queue_free()
	if not _doors[3]:
		$DoorRight.queue_free()
	
func on_up_door(body: CharacterBody2D):
	if is_room_active() and not body.get_node("CollisionShape2D").disabled:
		roomSpawner.move_room(0, -1)
	
func on_down_door(body: CharacterBody2D):
	if is_room_active() and not body.get_node("CollisionShape2D").disabled:
		roomSpawner.move_room(0, 1)
	
func on_left_door(body: CharacterBody2D):
	if is_room_active() and not body.get_node("CollisionShape2D").disabled:
		roomSpawner.move_room(-1, 0)

func on_right_door(body: CharacterBody2D):
	if is_room_active() and not body.get_node("CollisionShape2D").disabled:
		roomSpawner.move_room(1, 0)

func is_room_active():
	if not roomSpawner or not roomSpawner.room:
		return false
	return roomSpawner.room == self
	
func set_color(r, g, b):
	r = min(max(r, 0.4 + randf() / 5), 1)
	g  = min(max(g, 0.4 + randf() / 5), 1)
	b = min(max(b, 0.4 + randf() / 5), 1)
	color = Color(r,g,b)
	var color2 = Color(r+0.4,g+0.4,b+0.4)
	get_node("Background").modulate = color
	get_node("DoorUp").get_node("Sprite2D").modulate = color2
	get_node("DoorDown").get_node("Sprite2D").modulate = color2
	get_node("DoorLeft").get_node("Sprite2D").modulate = color2
	get_node("DoorRight").get_node("Sprite2D").modulate = color2
