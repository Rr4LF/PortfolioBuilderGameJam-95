class_name cheeseCardUI
extends Control

#References that match scene structure
#Finds and saves the references to specific child elements
@onready var title_label: Label = $title
@onready var icon_texture: TextureRect = $card_art
@onready var cost_label: Label = $card_cost

#
func set_card_data(card_data: Dictionary) -> void:
	if not is_node_ready():
		await ready
	title_label.text = card_data.get("title", "Unknown")
	cost_label.text = str(card_data.get("cost", 0))
	
	if card_data.has("texture"):
		icon_texture.texture = card_data["texture"]
