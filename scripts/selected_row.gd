class_name SelectedRowUI
extends HBoxContainer

# Node references
@onready var icon_rect: TextureRect = $icon
@onready var name_label: Label = $name_label
@onready var count_label: Label = $count_label

## Populates the row with the cheese icon, title, count, and total energy cost
func set_row_data(cheese_info: Dictionary, count: int) -> void:
	if not is_node_ready():
		await ready
	
	var title: String = cheese_info.get("title", "Unknown")
	var cost: int = cheese_info.get("cost", 0)
	
	name_label.text = title
	count_label.text = "x%d (-%d)" % [count, cost * count]
	
	if cheese_info.has("texture"):
		icon_rect.texture = cheese_info["texture"]
