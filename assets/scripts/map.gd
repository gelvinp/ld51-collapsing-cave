tool
class_name Map
extends Node2D
# Contains common information about a map sequence

enum MapType { STANDARD, CRAFTING, COMBAT }
enum TileType { BEDROCK = 0, STONE = 1, GREEN = 2, YELLOW = 3, RED = 4, LADDER = 5, HATCH = 6 }

export(MapType) var map_type = MapType.STANDARD
export(float, 0, 1, 0.05) var green_chance = 0.0
export(float, 0, 1, 0.05) var yellow_chance = 0.0
export(float, 0, 1, 0.05) var red_chance = 0.0

var tilemap: TileMap = null
var top_node: Node2D = null

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	if not Engine.editor_hint:
		tilemap = get_node("TileMap")
		top_node = get_node("Top")
		
		if map_type == MapType.STANDARD:
			spawn_resources()


func global_to_map(position: Vector2) -> Vector2:
	return tilemap.world_to_map(tilemap.to_local(position))


func map_to_global(position: Vector2) -> Vector2:
	return tilemap.to_global(tilemap.map_to_world(position))


func spawn_resources():
	for tile in tilemap.get_used_cells_by_id(TileType.STONE):
		var choices := []
		
		if green_chance > 0.0:
			choices.append(TileType.GREEN)
		if yellow_chance > 0.0:
			choices.append(TileType.YELLOW)
		if red_chance > 0.0:
			choices.append(TileType.RED)
		
		if choices.size() == 0:
			return
		
		# TODO: Make sure GDScript.randomize() is called on game start
		choices.shuffle()
		
		var chance: float = randf()
		
		match choices[0]:
			TileType.GREEN:
				if chance <= green_chance:
					tilemap.set_cellv(tile, TileType.GREEN)
			TileType.YELLOW:
				if chance <= yellow_chance:
					tilemap.set_cellv(tile, TileType.YELLOW)
			TileType.RED:
				if chance <= red_chance:
					tilemap.set_cellv(tile, TileType.RED)


func _get_configuration_warning():
	var map = find_node("TileMap")
	var top = find_node("Top")
	
	if (not map) or (not map is TileMap):
		return "Missing TileMap child named TileMap!"
	elif (not top) or (not top is Node2D):
		return "Missing Node2D child named Top!"
	
	return ""
