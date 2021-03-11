extends Node2D

func on_successful():
	$TargetPointIndicator.modulate = Color(0, 1, 0)

func reset():
	$TargetPointIndicator.modulate = Color(1, 1, 1)
