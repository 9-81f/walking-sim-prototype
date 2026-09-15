extends CanvasLayer
class_name Modals

@onready var end_game: EndGameModal = $EndGame

func _ready() -> void:
	UiEvents.end_game_modal_requested.connect(
		func():
			end_game.trigger_modal()
)
