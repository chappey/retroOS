extends Control


@onready var taskbar := $Taskbar
@onready var menu_button := $Taskbar/MenuButton

enum Progs {ABOUT=4, AI=1, TXT_ED=2, CUBE=3, TICTAC=5}

@onready var window: Array[Window] = [null, $AIWindow, $TxtEdWindow, $CubeWindow, $AboutWindow]




func _ready() -> void:
	menu_button.get_popup().connect(&"id_pressed", func(id: int):
		match id:
			Progs.ABOUT:
				window[Progs.ABOUT].show()
			Progs.AI:
				window[Progs.AI].show()
			Progs.TXT_ED:
				window[Progs.TXT_ED].show()
			Progs.CUBE:
				window[Progs.CUBE].show()
		)
