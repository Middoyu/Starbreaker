extends Node
signal scene_loaded(path)

var cache_ := []

func load_in_cache(path : String):
	cache_.push_back(load(path))
	emit_signal("scene_loaded", path)
