extends Node2D

onready var _box: Box = $Box
onready var _target_point_indicator: Node2D = $Floor/TargetPointIndicator
onready var _ui: UI = $UI

var _default_stats: Dictionary = {
	"time": 0.0,
	"error": 0.0,
	"velocity": 0.0,
	"output": 0.0,
	"score": 1000.0,
	"successful_countdown": 3.0,
	"successful": false,
}
var _stats_record: Array = []
var _stats: Dictionary = {}
var _target_point: float = 350.0 setget _set_target_point

func _set_target_point(new_target_point: float):
	_target_point = new_target_point
	if _target_point_indicator != null:
		_target_point_indicator.global_position.x = _target_point
		_box.target_point = _target_point

func get_error() -> float:
	return _target_point - _box.global_position.x 

func _ready():
	randomize()
	self._target_point = _target_point
	on_new_script_text(_ui.get_script_text())
	reset()

func _physics_process(delta: float):
	if _stats["successful"]:
		return
	var err: float = _box.get_control_system_error()
	if abs(err) < 5.0:
		_stats["successful_countdown"] -= delta
		if _stats["successful_countdown"] <= 0.0:
			_stats["successful_countdown"] = 0.0
			$Floor.on_successful()
			$Box.successful = true
			_stats["successful"] = true
	else:
		_stats["successful_countdown"] = 3.0
	_stats["time"] += delta
	_stats["error"] = _box.get_control_system_error()
	_stats["velocity"] = _box.velocity
	_stats["output"] = _box.last_control_system_output
	_stats["score"] -= abs(err) * delta
	_stats_record.append(_stats.duplicate(true))
	if _stats_record.size() > 60 * 100:
		OS.alert("YOU BEEN RUNNING THIS TOO LONG, IT'LL TAKE UP TOO MUCH MEMORY AND CRASH YOUR COMPUTER")
		reset()

func _get_stats_record_tsv() -> String:
	var to_return: String = ""
	for key in _stats.keys():
		to_return += str(key, "	")
	to_return += "\n"
	for stat in _stats_record:
		for key in stat.keys():
			to_return += str(stat[key]) + "	"
		to_return += "\n"
	return to_return

func on_new_script_text(script_text: String):
	var script = GDScript.new()
	script.source_code = script_text
	script.reload()
	var new_control_system: ControlSystem = ControlSystem.new()
	new_control_system.set_script(script)
	_box.current_control_system = new_control_system
	reset()

func reset():
	var opts: Dictionary = _ui.get_options()
	if opts["randomize_target_position"]:
		self._target_point = rand_range(0 + 25, 700 - 25) 
	else:
		self._target_point = opts["custom_target_position"]
	_stats = _default_stats.duplicate(true)
	_ui.stats = _stats
	_box.friction = opts["friction"]
	_box.reset()
	_stats_record.clear()
	$Floor.reset()


func _on_UI_new_control_system(script_text):
	on_new_script_text(script_text)


func _on_CopyButton_pressed():
	var record_text: String = _get_stats_record_tsv()
	if OS.get_name() == "HTML5":
		JavaScript.eval(str("setTextbox(\"", Marshalls.utf8_to_base64(record_text), "\")"))
	else:
		OS.clipboard = record_text


func _on_PutScript_pressed():
	JavaScript.eval(str("setScriptTextbox(\"", Marshalls.utf8_to_base64(_ui.get_script_text()), "\")"))

func _on_ReadScript_pressed():
	_ui.set_script_text(Marshalls.base64_to_utf8(JavaScript.eval("getScriptTextbox()")))
