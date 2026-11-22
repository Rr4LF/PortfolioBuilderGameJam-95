class_name cheeseCardUI
extends Control

# notify the parent menu when this card is clicked
signal card_selected(card_data: Dictionary)
signal card_deselected(card_data: Dictionary)

#References that match scene structure
#Finds and saves the references to specific child elements
@onready var title_label: Label = $title
@onready var icon_texture: TextureRect = $card_art
@onready var cost_label: Label = $card_cost
@onready var count_label: Label = get_node_or_null("count_label")

# Stores the dictionary data assigned to this specific card instance
var current_data: Dictionary = {}

func _ready() -> void:
	# Listen for mouse clicks/inputs on this card control
	gui_input.connect(_on_gui_input)

# 
## Populates the card's visual text, cost, image, and resets its selection count
func set_card_data(card_data: Dictionary) -> void:
	# Wait until child nodes are initialized if this is called very early
	if not is_node_ready():
		await ready
		
	current_data = card_data
	title_label.text = card_data.get("title", "Unknown")
	cost_label.text = str(card_data.get("cost", 0))
	
	# Only set the texture if the dictionary includes one
	if card_data.has("texture"):
		icon_texture.texture = card_data["texture"]
		
	# Start with 0 selected when first populated
	set_count(0)

## Updates the count display or hides it when amount is 0
func set_count(amount: int) -> void:
	if count_label:
		count_label.text = "x%d" % amount if amount > 0 else ""

## Detects left-click (select/add) and right-click (deselect/refund) on the card
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			card_selected.emit(current_data)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			card_deselected.emit(current_data)
