extends Resource
class_name ItemData

enum ItemType {
	CONSUMABLE,
	EQUIPPABLE,
	INSPECTABLE,
	CARRYABLE,
	KEY,
}

enum HandSlot {
	NONE,
	RIGHT_HAND,
	LEFT_HAND,
	TWO_HANDED
}

@export_group("Identity & UI")
@export var id: String = "item_id"
@export var display_name: String = "New Item"
@export_multiline var description: String = ""
@export var icon: Texture2D
@export var mesh: Mesh
@export var type: ItemType

@export_group("Equip Scene Settings")
@export var hand_slot: HandSlot
@export var equip_scene: PackedScene

@export_group("Inventory Logic")
@export var is_storable: bool = true
@export var is_stackable: bool = false
@export_range(1, 99) var max_stack_size: int = 1
@export var weight: float = 0.5
@export var value: int = 10

@export_group("Inspection Settings")
@export_multiline var readable_text: String = ""

@export_group("Stats Modifiers")
@export var stats_modifiers: Dictionary[String, Variant]
