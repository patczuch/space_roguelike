extends Control

var player: CharacterBody2D
@onready var hearts = [$Heart1, $Heart2, $Heart3]

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]
	if player:
		for i in range(len(hearts)):
			hearts[i].visible = player.health > i
	else:
		for heart in hearts:
			heart.visible = false
