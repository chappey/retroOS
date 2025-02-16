extends PanelContainer


@onready var lbl := $RichTextLabel as RichTextLabel

func _ready() -> void:
	pass


func set_text(txt: String) -> void:
	lbl.text = txt
