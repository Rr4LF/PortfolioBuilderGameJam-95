extends Node2D

@onready var door: AnimatedSprite2D = $bg/door
@onready var start_button: BaseButton = $bg/start


func _ready() -> void:
	door.animation = "door"
	door.frame = 0
	door.stop()


# note to self: if no previous progress/save found, play starting cutscene
# note: other options are items too? works rn so put this off, focus muna sa main game :p
func _on_start_pressed() -> void:
	start_button.disabled = true
	door.play("door")
	await door.animation_finished
	get_tree().change_scene_to_file("res://scenes/between_shifts_menu.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
