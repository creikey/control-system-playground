extends Reference

class_name ControlSystem

func compute_output(error: float, time: float) -> float:
	push_error("Must implement compute_output!")
	return sin(error/500.0 + 500.0) * 900.0
