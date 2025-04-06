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
	if is_room_active():
		roomSpawner.move_room(0, -1)
	
func on_down_door(body: CharacterBody2D):
	if is_room_active():
		roomSpawner.move_room(0, 1)
	
func on_left_door(body: CharacterBody2D):
	if is_room_active():
		roomSpawner.move_room(-1, 0)

func on_right_door(body: CharacterBody2D):
	if is_room_active():
		roomSpawner.move_room(1, 0)

func is_room_active():
	return roomSpawner.room == self
