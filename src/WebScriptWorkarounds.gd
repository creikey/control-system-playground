extends HBoxContainer

func _ready():
	visible = OS.get_name() == "HTML5"
