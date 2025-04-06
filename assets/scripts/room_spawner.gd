extends Node2D
class_name RoomSpawner

var room_scene: PackedScene = preload("res://assets/scenes/Room.tscn")
var player_scene: PackedScene = preload("res://assets/scenes/Player.tscn")

var room: Room
var player: Player
var floor: Array
var curr_room: Vector2

func _ready():
	var width = 10
	var height = 10
	var start_room_x = 5
	var start_room_y = 4

	player = player_scene.instantiate()
	player.global_position = Vector2(640, 360)
	add_child(player)
	
	curr_room = Vector2(start_room_x, start_room_y)
	
	for i in range(width):
		floor.append([])
		for j in range(height):
			floor[i].append(null)
			
	var room_presets = load_files("res://assets/rooms/")
	
	var plan = generate_floorplan(7, 15, width, height)
	for y in range(len(plan)):
		print(plan[y])
		for x in range(len(plan[y])):
			if plan[y][x] != 0:
				var tmp_room = room_scene.instantiate()
				tmp_room.roomSpawner = self
				tmp_room.set_doors([y-1 >= 0 and plan[y-1][x] != 0, y+1 < height and plan[y+1][x] != 0, x-1 >= 0 and plan[y][x-1] != 0, x+1 < width and plan[y][x+1] != 0])
				if x == start_room_x and y == start_room_y:
					room = tmp_room
					add_child(room)
					room.z_index = -1
				else:
					tmp_room.load_from_file(room_presets[randi() % room_presets.size()])
					pause_room(tmp_room, true)
				floor[y][x] = tmp_room
				

func move_room(x, y):
	pause_room(room, true)
	if x == 1:
		player.global_position = Vector2(170, player.global_position.y)
	if x == -1:
		player.global_position = Vector2(1110, player.global_position.y)
	if y == 1:
		player.global_position = Vector2(player.global_position.x, 130)
	if y == -1:
		player.global_position = Vector2(player.global_position.x, 550)
	curr_room = Vector2(curr_room[0] + x, curr_room[1] + y)
	remove_child(room)
	room = floor[curr_room[1]][curr_room[0]]
	add_child(room)
	room.z_index = -1
	pause_room(room, false)
	
func pause_room(room, pause):
	pass
	
func ncount(x, y, grid, WIDTH, HEIGHT):
	var count = 0
	for d in [[-1,0], [1,0], [0,-1], [0,1]]:
		var nx = x + d[0]
		var ny = y + d[1]
		if 0 <= nx and nx < WIDTH and 0 <= ny and ny < HEIGHT and grid[ny][nx] > 0:
			count += 1
	return count


func visit(x, y, grid, WIDTH, HEIGHT, placed, max_rooms, cell_queue):
	if not (0 <= x and x < WIDTH and 0 <= y and y < HEIGHT):
		return false
	if grid[y][x] > 0:
		return false
	if ncount(x, y, grid, WIDTH, HEIGHT) > 1:
		return false
	if len(placed) >= max_rooms:
		return false
	if (x != 5 or y != 4) and randfn(0.0, 1.0) < 0.5:
		return false
	grid[y][x] = 1
	placed.append([x, y])
	cell_queue.append([x, y])
	return true
		
		
func generate_floorplan(min_rooms=7, max_rooms=15, WIDTH=10, HEIGHT=10):
	var endrooms = []
	var grid = []

	while true:
		grid = []
		for i in range(WIDTH):
			grid.append([])
			for j in range(HEIGHT):
				grid[i].append(0)
		var placed = []
		var cell_queue = []
		endrooms = []

		visit(5, 4, grid, WIDTH, HEIGHT, placed, max_rooms, cell_queue)

		while cell_queue:
			var tmp = cell_queue.pop_front()
			var x = tmp[0]
			var y = tmp[1]
			var created = false
			for d in [[-1,0], [1,0], [0,-1], [0,1]]:
				if visit(x + d[0], y + d[1], grid, WIDTH, HEIGHT, placed, max_rooms, cell_queue):
					created = true
			if not created:
				endrooms.append([x, y])

		if len(placed) >= min_rooms:
			break

	var boss_room = endrooms.pop_back()
	grid[boss_room[1]][boss_room[0]] = 2  # boss

	var reward_room = endrooms.pop_back()
	grid[reward_room[1]][reward_room[0]] = 3  # reward

	return grid
	
func load_files(folder_path: String) -> Array:
	var file_contents = []
	var dir = DirAccess.open(folder_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var file_path = folder_path + "/" + file_name
				var file = FileAccess.open(file_path, FileAccess.READ)
				if file:
					var content = file.get_as_text()
					file_contents.append(content)
					file.close()
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to open directory: %s" % folder_path)

	return file_contents
