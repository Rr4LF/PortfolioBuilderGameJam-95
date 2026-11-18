extends Control

## Back button that leads back to main menu
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

const CHEESE_CARD_SCENE = preload("res://scenes/cheese_card.tscn")

@onready var card_scroll_container: ScrollContainer = $card_scroll_container
@onready var card_container: GridContainer = $card_scroll_container/card_margin/card_container

var v_scrollbar: VScrollBar
var hide_timer: Timer
var fade_tween: Tween
var scroll_tween: Tween
var target_scroll_y: float = 0.0

## Dictionary containing all available cheeses
var cheese_menu: Array[Dictionary] = [
	{
		"title": "American Cheese",
		"cost": 2,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_americancheese.png")
	},
	{
		"title": "Asiago Cheese",
		"cost": 5,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_asiagocheese.png")
	},
	{
		"title": "Blue Cheese",
		"cost": 5,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_bluecheese.png")
	},
	{
		"title": "Brie Cheese",
		"cost": 5,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_briecheese.png")
	},
	{
		"title": "Cottage Cheese",
		"cost": 6,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_cottagecheese.png")
	},
	{
		"title": "Fresh Cheese",
		"cost": 6,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_freshcheese.png")
	},
	{
		"title": "Goat Cheese",
		"cost": 6,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_goatcheese.png")
	},
	{
		"title": "Gouda Cheese",
		"cost": 6,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_goudacheese.png")
	},
	{
		"title": "Mozarella",
		"cost": 9,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_mozarella.png")
	},
	{
		"title": "Pepperjack Cheese",
		"cost": 8,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_pepperjackcheese.png")
	},
	{
		"title": "Swiss Cheese",
		"cost": 8,
		"texture": preload("res://assets/between_shifts (cheesemaking)/Cheeses/mini_swisscheese.png")
	}
]

## Runs populate_menu() when scene is loaded
func _ready() -> void:
	populate_menu()
	_setup_auto_hide_scrollbar()
	card_scroll_container.gui_input.connect(_on_scroll_gui_input)

## Populates the between_shifts_menu with all available cheeses in the Dictionary
func populate_menu() -> void:
	for child in card_container.get_children():
		child.queue_free()
	
	for cheese_info in cheese_menu:
		var new_card: cheeseCardUI = CHEESE_CARD_SCENE.instantiate()
		card_container.add_child(new_card)
		new_card.set_card_data(cheese_info)

# sets a half second timer to hide scrollbar
func _setup_auto_hide_scrollbar() -> void:
	v_scrollbar = card_scroll_container.get_v_scroll_bar()
	v_scrollbar.modulate.a = 0.0
	
	hide_timer = Timer.new()
	hide_timer.wait_time = 0.5
	hide_timer.one_shot = true
	hide_timer.timeout.connect(_on_hide_timer_timeout)
	add_child(hide_timer)
	
	v_scrollbar.value_changed.connect(_on_scrolling)
	card_scroll_container.scroll_started.connect(_on_scrolling)

# shows scrollbar while scrolling
func _on_scrolling(_value: float = 0.0) -> void:
	if fade_tween:
		fade_tween.kill()
	
	v_scrollbar.modulate.a = 1.0
	hide_timer.start()

# scrollbar fades out if not scrolling
func _on_hide_timer_timeout() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(v_scrollbar, "modulate:a", 0.0, 0.7)

# smooth scrolling (will fix comments once reread/revised)
func _on_scroll_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var dir := int(event.button_index == MOUSE_BUTTON_WHEEL_DOWN) - int(event.button_index == MOUSE_BUTTON_WHEEL_UP)
		if dir != 0:
			if not scroll_tween or not scroll_tween.is_running():
				target_scroll_y = card_scroll_container.scroll_vertical
			
			var max_y := maxf(0.0, v_scrollbar.max_value - v_scrollbar.page)
			target_scroll_y = clampf(target_scroll_y + dir * 100.0, 0.0, max_y)
			
			if scroll_tween: scroll_tween.kill()
			scroll_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			scroll_tween.tween_property(card_scroll_container, "scroll_vertical", roundi(target_scroll_y), 0.25)
			card_scroll_container.accept_event()
