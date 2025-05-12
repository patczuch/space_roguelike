extends Control

var player: CharacterBody2D
@onready var hearts = [$Heart1, $Heart2, $Heart3, $Heart4, $Heart5, $Heart6, $Heart7, $Heart8, $Heart9, $Heart10, $Heart11, $Heart12]
@onready var room_icons = [$RoomIcon, $RoomIcon2, $RoomIcon3, $RoomIcon4, $RoomIcon5, $RoomIcon6, $RoomIcon7, $RoomIcon8, $RoomIcon9, $RoomIcon10, $RoomIcon11, $RoomIcon12, $RoomIcon13, $RoomIcon14, $RoomIcon15, $RoomIcon16, $RoomIcon17, $RoomIcon18, $RoomIcon19, $RoomIcon20, $RoomIcon21, $RoomIcon22, $RoomIcon23, $RoomIcon24, $RoomIcon25, $RoomIcon26, $RoomIcon27, $RoomIcon28, $RoomIcon29, $RoomIcon30, $RoomIcon31, $RoomIcon32, $RoomIcon33, $RoomIcon34, $RoomIcon35, $RoomIcon36, $RoomIcon37, $RoomIcon38, $RoomIcon39, $RoomIcon40, $RoomIcon41, $RoomIcon42, $RoomIcon43, $RoomIcon44, $RoomIcon45, $RoomIcon46, $RoomIcon47, $RoomIcon48, $RoomIcon49, $RoomIcon50, $RoomIcon51, $RoomIcon52, $RoomIcon53, $RoomIcon54, $RoomIcon55, $RoomIcon56, $RoomIcon57, $RoomIcon58, $RoomIcon59, $RoomIcon60, $RoomIcon61, $RoomIcon62, $RoomIcon63, $RoomIcon64, $RoomIcon65, $RoomIcon66, $RoomIcon67, $RoomIcon68, $RoomIcon69, $RoomIcon70, $RoomIcon71, $RoomIcon72, $RoomIcon73, $RoomIcon74, $RoomIcon75, $RoomIcon76, $RoomIcon77, $RoomIcon78, $RoomIcon79, $RoomIcon80, $RoomIcon81, $RoomIcon82, $RoomIcon83, $RoomIcon84, $RoomIcon85, $RoomIcon86, $RoomIcon87, $RoomIcon88, $RoomIcon89, $RoomIcon90, $RoomIcon91, $RoomIcon92, $RoomIcon93, $RoomIcon94, $RoomIcon95, $RoomIcon96, $RoomIcon97, $RoomIcon98, $RoomIcon99, $RoomIcon100]
@onready var player_icon = $PlayerIcon

func add_points(points) -> void:
	$Points.text = str(int($Points.text) + points)

func _ready() -> void:
	for i in range(len(room_icons)):
			room_icons[i].visible = false
			room_icons[i].z_index = 100
	player_icon.z_index = 101
	$Points.text = Global.points

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]
	if player:
		for i in range(len(hearts)):
			hearts[i].visible = player.health > i
	else:
		for heart in hearts:
			heart.visible = false
	
	if get_tree().get_root().get_node("RoomSpawner").get_node("Room"):
		var room = get_tree().get_root().get_node("RoomSpawner").get_node("Room")
		var pos = room.roomPosition
		room_icons[pos.x + pos.y * 10].visible = true
		room_icons[pos.x + pos.y * 10].modulate = Color(room.color, 0.8)
		player_icon.global_position = room_icons[pos.x + pos.y * 10].global_position
		if room.get_node("DoorUp"):
			if not room_icons[pos.x + (pos.y-1) * 10].visible:
				room_icons[pos.x + (pos.y-1) * 10].visible = true
				room_icons[pos.x + (pos.y-1) * 10].modulate = Color(0.5, 0.5, 0.5, 0.5)
		if room.get_node("DoorDown"):
			if not room_icons[pos.x + (pos.y+1) * 10].visible:
				room_icons[pos.x + (pos.y+1) * 10].visible = true
				room_icons[pos.x + (pos.y+1) * 10].modulate = Color(0.5, 0.5, 0.5, 0.5)
		if room.get_node("DoorLeft"):
			if not room_icons[pos.x-1 + pos.y * 10].visible:
				room_icons[pos.x-1 + pos.y * 10].visible = true
				room_icons[pos.x-1 + pos.y * 10].modulate = Color(0.5, 0.5, 0.5, 0.5)
		if room.get_node("DoorRight"):
			if not room_icons[pos.x+1 + pos.y * 10].visible:
				room_icons[pos.x+1 + pos.y * 10].visible = true
				room_icons[pos.x+1 + pos.y * 10].modulate = Color(0.5, 0.5, 0.5, 0.5)
