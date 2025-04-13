extends Node2D
class_name Room

var roomSpawner: RoomSpawner
var exited: bool

func load_from_file(text: String):
	var lines = text.split("\n")
	for line in lines:
		var params = line.split(" ")
		var object = load("res://assets/scenes/" + params[0] + ".tscn").instantiate()
		object.global_position = Vector2(float(params[1]), float(params[2]))
		add_child(object)
		
		
func _process(delta: float):
	for node in get_children():
		if node.is_in_group("enemies"):
			if $DoorUp:
				$DoorUp.visible = false
				$DoorUp.get_node("CollisionShape2D").disabled = true
			if $DoorDown:
				$DoorDown.visible = false
				$DoorDown.get_node("CollisionShape2D").disabled = true
			if $DoorLeft:
				$DoorLeft.visible = false
				$DoorLeft.get_node("CollisionShape2D").disabled = true
			if $DoorRight:
				$DoorRight.visible = false
				$DoorRight.get_node("CollisionShape2D").disabled = true
		else:
			if $DoorUp:
				$DoorUp.visible = true
				$DoorUp.get_node("CollisionShape2D").disabled = false
			if $DoorDown:
				$DoorDown.visible = true
				$DoorDown.get_node("CollisionShape2D").disabled = false
			if $DoorLeft:
				$DoorLeft.visible = true
				$DoorLeft.get_node("CollisionShape2D").disabled = false
			if $DoorRight:
				$DoorRight.visible = true
				$DoorRight.get_node("CollisionShape2D").disabled = false

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
	return roomSpawner.room == self
