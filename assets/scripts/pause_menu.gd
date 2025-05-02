extends Control

@onready var resume_button = $ResumeButton
@onready var exit_button = $ExitButton
@onready var exit_button2 = $ExitButton2
@onready var retry_button = $RetryButton
@onready var game_over = $GameOver

func _ready() -> void:
	resume_button.disabled = true
	exit_button.disabled = true
	exit_button2.disabled = true
	retry_button.disabled = true
	resume_button.visible = false
	exit_button.visible = false
	exit_button2.visible = false
	retry_button.visible = false
	game_over.visible = false
	
func _process(delta: float) -> void:
	if resume_button.disabled and Input.is_action_just_pressed("pause"):
		resume_button.disabled = false
		exit_button.disabled = false
		resume_button.visible = true
		exit_button.visible = true
		Engine.time_scale = 0
	elif not resume_button.disabled and Input.is_action_just_pressed("pause"):
		resume_button.disabled = true
		exit_button.disabled = true
		resume_button.visible = false
		exit_button.visible = false
		Engine.time_scale = 1

func _on_exit_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://assets/scenes/MainMenu.tscn")


func _on_resume_button_pressed() -> void:
	Engine.time_scale = 1
	resume_button.disabled = true
	exit_button.disabled = true
	resume_button.visible = false
	exit_button.visible = false

func show_game_over():
	exit_button2.disabled = false
	retry_button.disabled = false
	exit_button2.visible = true
	retry_button.visible = true
	game_over.visible = true


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/RoomSpawner.tscn")
