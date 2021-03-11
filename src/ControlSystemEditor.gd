extends CanvasLayer

class_name UI

signal new_control_system(script_text)

export (PackedScene) var _stat_display_pack

onready var _editor: TextEdit = $VSplitContainer/VBoxContainer/TextEdit
onready var _stats_vbox: VBoxContainer = $VSplitContainer/VBoxContainer/Stats
# {
# "stat name": 5.0
# }
var stats: Dictionary = {} setget set_stats

func set_stats(new_stats: Dictionary):
	stats = new_stats
	if _stats_vbox != null:
		for c in _stats_vbox.get_children():
			c.queue_free()
		for stat_name in stats.keys():
			var new_stat_display: StatDisplay = _stat_display_pack.instance()
			_stats_vbox.add_child(new_stat_display)
			new_stat_display.stat_name_label.text = stat_name
			new_stat_display.stat_value_label.text = str(stats[stat_name])

func get_options() -> Dictionary:
	return {
		"randomize_target_position": $VSplitContainer/VBoxContainer/Options/HBoxContainer/RandomizeStartCheckButton.pressed,
		"custom_target_position": float($VSplitContainer/VBoxContainer/Options/HBoxContainer2/CustomTargetLineEdit.text),
		"friction": float($VSplitContainer/VBoxContainer/Options/HBoxContainer3/FrictionLineEdit.text),
	}

func set_script_text(new_text: String):
	_editor.text = new_text
	emit_signal("new_control_system", new_text)

func get_script_text():
	return _editor.text

func _on_ReloadButton_pressed():
	emit_signal("new_control_system", _editor.text)

func _process(_delta):
	for stat_display in _stats_vbox.get_children():
		var new_stat_value = stats[stat_display.stat_name_label.text]
		if new_stat_value is float:
			new_stat_value = stepify(new_stat_value, 0.1)
		stat_display.stat_value_label.text = str(new_stat_value)
