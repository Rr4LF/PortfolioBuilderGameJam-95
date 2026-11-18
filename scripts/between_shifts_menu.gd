extends Control

##Back button that leads back to main menu
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

const CHEESE_CARD_SCENE = preload("res://scenes/cheese_card.tscn")
@onready var card_container: GridContainer = $card_container

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

## Populates the between_shifts_menu with all available cheeses in the Dictionary
func populate_menu() -> void:
	
	for child in card_container.get_children():
		child.queue_free()
	
	for cheese_info in cheese_menu:
		var new_card: cheeseCardUI = CHEESE_CARD_SCENE.instantiate()
		card_container.add_child(new_card)
		new_card.set_card_data(cheese_info)
