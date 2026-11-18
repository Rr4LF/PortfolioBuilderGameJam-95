extends Node2D

@export var max_offset: Vector2 = Vector2(30.0, 20.0) # max movement, in pixels
@export var smoothing: float = 5.0 # higher val = snappier movement

var start_position: Vector2

func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	var normalized_mouse: Vector2 = (mouse_pos / viewport_size) * 2.0 - Vector2.ONE
	
	# prevents the image from over-shifting/moving out of frame
	normalized_mouse = normalized_mouse.clamp(-Vector2.ONE, Vector2.ONE)
	
	# main movement
	var target_position: Vector2 = start_position - (normalized_mouse * max_offset)
	position = position.lerp(target_position, smoothing * delta)
