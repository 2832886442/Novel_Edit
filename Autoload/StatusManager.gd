extends Node

signal AddSomething(status)
signal StatusChange(status)

enum STATUS{
	NOTE,
	CREATION,
	CHARACTER,
	ADD_NOTE,
	ADD_CREATION,
	ADD_CHARACTER
}

var current_status = STATUS.NOTE

func _ready() -> void:
	StatusChange.connect(status_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func status_changed(status):
	current_status = status
