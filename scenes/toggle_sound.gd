extends TextureButton

var music_bus = AudioServer.get_bus_index("Music")

const MUTED: Texture2D = preload("res://assets/main_menu/muted.png")
const MUTED_hover: Texture2D = preload("res://assets/main_menu/muted_hover.png")
const MUTED_pressed: Texture2D = preload("res://assets/main_menu/muted_pressed.png")

const UNMUTED: Texture2D = preload("res://assets/main_menu/unmuted.png")
const UNMUTED_hover: Texture2D = preload("res://assets/main_menu/unmuted_hover.png")
const UNMUTED_pressed: Texture2D = preload("res://assets/main_menu/unmuted_pressed.png")


func _ready() -> void:
	_update_icon()

func _on_pressed() -> void:
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
	_update_icon()

func _update_icon() -> void:
	if AudioServer.is_bus_mute(music_bus):
		texture_normal = MUTED
		texture_pressed = MUTED_pressed
		texture_hover = MUTED_hover
	else:
		texture_normal = UNMUTED
		texture_pressed = UNMUTED_pressed
		texture_hover = UNMUTED_hover
