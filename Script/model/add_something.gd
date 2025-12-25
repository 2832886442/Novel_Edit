extends Control

@onready var texture_button: TextureButton = $TextureButton

var status = StatusManager.STATUS.NOTE

func _ready() -> void:
	texture_button.pressed.connect(add_something)

func _process(delta: float) -> void:
	pass

func add_something():
	StatusManager.emit_signal("AddSomething",self.status)
