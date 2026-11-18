extends AnimatedSprite2D

@export_file("*.tscn") var next_scene_path: String
@onready var click_button: Button = $Button

func _ready() -> void:
	animation = "open"
	frame = 0
	stop()
	click_button.pressed.connect(_on_door_clicked)

func _on_door_clicked() -> void:
	click_button.disabled = true
	play("open")
	await animation_finished
	
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
