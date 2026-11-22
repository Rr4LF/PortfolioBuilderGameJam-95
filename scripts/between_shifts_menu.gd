extends Control

# Starting energy it is adjustable in Inspector
@export var starting_energy: int = 20
# Remaining energy as the player picks or removes cheeses
var total_energy: int = 20

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

# Tracks how many of each cheese have been chosen
var selected_counts: Dictionary = {}
# Keeps references to each spawned card via title
var spawned_cards: Dictionary = {}
# Displays the current remaining energy
@onready var energy_label: Label = $total_energy/energy_label

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

## Initializes the menu when the scene loads
func _ready() -> void:
	total_energy = starting_energy
	_update_energy_ui()
	
	populate_menu()
	_setup_auto_hide_scrollbar()
	card_scroll_container.gui_input.connect(_on_scroll_gui_input)

## Populates the between_shifts_menu with all available cheeses in the Dictionary
func populate_menu() -> void:
# Remove any old cards before rebuilding the list
	for child in card_container.get_children():
		child.queue_free()
		
	# Reset tracking for a fresh menu
	spawned_cards.clear()
	selected_counts.clear()
	
	# Spawn a card for every cheese entry in cheese_menu
	for cheese_info in cheese_menu:
		var title: String = cheese_info.get("title", "Unknown")
		selected_counts[title] = 0 # Make this cheese's picked count 0
		
		var new_card: cheeseCardUI = CHEESE_CARD_SCENE.instantiate()
		card_container.add_child(new_card)
		new_card.set_card_data(cheese_info)
		
		# Connect card click signals to handler functions in this menu
		new_card.card_selected.connect(_on_card_selected)
		new_card.card_deselected.connect(_on_card_deselected)
		
		spawned_cards[title] = new_card

## Called when a card is left-clicked: increases cheese count and spends energy
func _on_card_selected(cheese_info: Dictionary) -> void:
	var title: String = cheese_info.get("title", "Unknown")
	var cost: int = cheese_info.get("cost", 0)
	
	# Stop if the player doesn't have enough energy left to afford this cheese
	if total_energy < cost:
		return
		
	selected_counts[title] += 1 # Increment count for this specific cheese
	total_energy -= cost # Deduct cheese cost from total energy
	
	# Update both the card's count badge and the energy display
	spawned_cards[title].set_count(selected_counts[title])
	_update_energy_ui()

## Called when a card is right-clicked: decreases cheese count and refunds energy
func _on_card_deselected(cheese_info: Dictionary) -> void:
	var title: String = cheese_info.get("title", "Unknown")
	var cost: int = cheese_info.get("cost", 0)
	
	# Do nothing if none of this cheese are currently selected
	if selected_counts.get(title, 0) <= 0:
		return
		
	selected_counts[title] -= 1 # Decrement count for this specific cheese
	total_energy += cost # Refund cheese cost back to total energy
	
	# Update both the card's count badge and the energy display
	spawned_cards[title].set_count(selected_counts[title])
	_update_energy_ui()

## Updates the energy label text with the current remaining energy
func _update_energy_ui() -> void:
	if energy_label is Label:
		energy_label.text = str(total_energy)

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
