tool
extends EditorPlugin

# Replace this value with a PascalCase autoload name, as per the GDScript style guide.
const AUTOLOAD_NAME = "MiNetwork"

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/mI/mi_network.gd")
	#				Name of custom,  Parent type, 	Script Name, 				picture
	#
	add_custom_type("mI_CheckBox", 	"CheckBox", 	preload("mI_CheckBox.gd"), 	preload("mI_checkbox.svg"))
	add_custom_type("mI_Label", 	"Label", 		preload("mI_Label.gd"), 	preload("mI_Label.svg"))
	add_custom_type("mI_Button", 	"Button", 		preload("mI_Button.gd"), 	preload("mI_Button.svg"))
	add_custom_type("mI_Indicator", "Polygon2D", 	preload("mI_Indicator.gd"), preload("mI_checkbox.svg"))
	add_custom_type("mI_Rotate",    "Sprite", 		preload("mI_Indicator_rotate.gd"), preload("fan.png"))
	add_custom_type("mI_ControlPopup", "Control", 	preload("mi_ControlPopup.gd"), preload("mI_Popup.png"))
	print_debug("microInterface addon activated")

	pass


func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
	remove_custom_type("mI_CheckBox")
	remove_custom_type("mI_Label")
	remove_custom_type("mI_Button")
	remove_custom_type("mI_Indicator")
	remove_custom_type("mI_Rotate")
	remove_custom_type("mI_ControlPopup")
	print_debug("microInterface addon deactivated")
	
	pass
