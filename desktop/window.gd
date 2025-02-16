extends Window


func _ready() -> void:
	connect("close_requested", func(): hide())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hide()
