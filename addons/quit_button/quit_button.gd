@tool
@icon("res://addons/quit_button/quit_button.svg")
class_name QuitButton
extends Button

## QuitButton
##
## Quits the application when pressed.
## NOTE: It is highly suggested to modify the [member Button.process_mode] of this in order for it to
## process with the tree's expected [member SceneTree.paused] state.

enum RemovalBehaviour{
	NONE, ## Do not remove
	FREE, ## Free the button
	HIDE ## Make the node invisible
}

const REMOVAL_PLATFORMS := ["Web"]

## When the target platform is unquitable, this the button will be removed
## using this specified [enum RemovalBehaviour].
@export var removal_behaviour := RemovalBehaviour.FREE

## Exit code to used when exiting.
@export var exit_code:int = 0

## Unpause the tree before quitting.
@export var unpause_before_quit := true

## Propigate a [constant Node.NOTIFICATION_WM_CLOSE_REQUEST] notification from the
## root node of the current tree before quitting.[br]
## Done [i]after[/i] [member unpause_before_quit].
@export var send_close_request_notification := true

func _ready():
	if (not is_inside_tree()) or OS.get_name() in REMOVAL_PLATFORMS:
		match(removal_behaviour):
			RemovalBehaviour.FREE:
				queue_free()
			RemovalBehaviour.HIDE:
				hide()

func _property_can_revert(property: StringName) -> bool:
	match(property):
		"text", "process_mode":
			return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	match(property):
		"text":
			return "Quit"
		"process_mode":
			return PROCESS_MODE_ALWAYS
	return null

func _validate_property(property: Dictionary):
	match(property.name):
		"toggle_mode":
			property.usage = PROPERTY_USAGE_NO_EDITOR

func _pressed():
	_on_quit()

func _on_quit():
	var tree := get_tree()
	if tree != null:
		if unpause_before_quit:
			tree.paused = false
		if send_close_request_notification:
			tree.root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		tree.call_deferred("quit", exit_code)
