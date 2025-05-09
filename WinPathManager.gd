extends Node3D

# Tracks tiles that have been visited
var visited_tiles := {}
# Defines the correct order of tiles to step on
var correct_order := ["Tile1", "Tile2", "Tile3"]
var current_index := 0

@onready var message_label: Label = $"/root/Main/CanvasLayer/MessageLabel"


func _ready():
	for tile in get_tree().get_nodes_in_group("win_path"):
		visited_tiles[tile] = false
		tile.body_entered.connect(_on_win_tile_body_entered.bind(tile))
		
		
# Called when the player enters a tile's Area3D
func _on_win_tile_body_entered(body: Node3D, tile: Area3D) -> void:
	if body.name == "Player" or body.name == "PlayerCam":
		var expected_tile_name = correct_order[current_index]

		if tile.name == expected_tile_name:
			visited_tiles[tile] = true
			current_index += 1

			var mesh: MeshInstance3D = tile.get_node("MeshInstance3D")
			var original_material: Material = mesh.get_active_material(0)
			var new_material: StandardMaterial3D = StandardMaterial3D.new()

			if original_material is StandardMaterial3D:
				new_material = original_material.duplicate()

			new_material.albedo_color = Color.LIME_GREEN
			mesh.set_surface_override_material(0, new_material)

			show_message("✅ Great! You stepped on " + tile.name)

			# If all tiles have been visited in the correct order
			if current_index == correct_order.size():
				message_label.text = "🎉 YOU WIN! You reached the tent!"
				trigger_win()
		else:
			# Player stepped on the wrong tile
			show_message("❌ Wrong tile! This is " + tile.name + ". Look for " + correct_order[current_index])

# Displays a message on screen for a short time
func show_message(msg: String, duration := 2.0):
	message_label.text = msg
	message_label.show()
	await get_tree().create_timer(duration).timeout
	message_label.hide()



# Called when the player completes the tile sequence
func trigger_win():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	print("🎉 Game Over – You reached the tent!")
