extends Control

@export var default_music_volume: float = 0.05

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

@onready var music_slider: HSlider = $music_slider
@onready var music_label: Label = get_node_or_null("music_label")

@export var bus_name: String = "Music"
var bus_index: int = 0

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		bus_index = 0
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(default_music_volume))
	var current_db: float = AudioServer.get_bus_volume_db(bus_index)
	var current_linear: float = db_to_linear(current_db)

	music_slider.value = current_linear
	_update_volume_ui(current_linear)

	music_slider.value_changed.connect(_on_music_slider_value_changed)

func _on_music_slider_value_changed(value: float) -> void:
	if value <= 0.001:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

	_update_volume_ui(value)

func _update_volume_ui(value: float) -> void:
	if music_label:
		music_label.text = "Music: %d%%" % roundi(value * 100.0)
