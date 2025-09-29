@tool
@icon("./restart_button.svg")
class_name RestartButton
extends QuitButton

func _property_can_revert(property: StringName) -> bool:
	match(property):
		"text":
			return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	match(property):
		"text":
			return tr("Restart")
	return null

func _on_quit():
	if not is_impossible() and not Engine.is_editor_hint():
		OS.set_restart_on_exit(true, OS.get_cmdline_args())
	super()
