extends Node
# UIEvents Autoload

## HUD UI signals
signal toast_requested(message: String, icon: Texture2D)
signal display_interaction_prompt_requested(prompt_data: Interactable3D.PromptData)
signal dismiss_interaction_prompt_requested

## Inventory UI signals
signal item_use_requested(item: ItemData, qty: int)
signal item_stow_requested(item: ItemData, qty: int)
signal item_drop_requested(item: ItemData, qty: int)

## Inspect UI signals
signal item_inspection_requested(item: ItemData)

## UI Audio signals
signal ui_audio_requested(stream: AudioStream)
